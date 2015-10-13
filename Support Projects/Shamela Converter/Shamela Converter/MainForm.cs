using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Data.SqlClient;
using System.Data.OleDb;
using iShamela.DataType;
using Ionic.Zip;

namespace iShamela
{
    public partial class MainForm : Form
    {
        List<string> _files = new List<string>();
        List<string> _archives = new List<string>();
        List<string> _archivesFiles = new List<string>();
        List<BokTable> _boks = new List<BokTable>();
        List<CatTable> _cats = new List<CatTable>();
        List<string> _mdbs = new List<string>();

        public MainForm()
        {
            InitializeComponent();
        }

        private void UpdateFiles()
        {
            listFiles.Items.Clear();
            _mdbs.Clear();
            foreach (string file in _files)
            {
                listFiles.Items.Add(Path.GetFileName(file));
                _mdbs.Add(Path.GetFileName(file));
            }
        }

        private void UpdateBooks()
        {
            if (listFiles.Items.Contains("main.mdb"))
            {
                DbJet reader = new DbJet();
                int index = listFiles.Items.IndexOf("main.mdb");

                reader.Connect(_files[index]);

                OleDbDataReader read = reader.Read("select * from 0bok");

                _boks = BokTable.Fill(reader);
                _cats = CatTable.Fill(reader);

                listBooks.Items.Clear();
                int counter = 1;
                foreach (BokTable bok in _boks)
                {
                    listBooks.Items.Add(string.Format("{0}.{1}", counter++, bok.Bk));
                }

                lblBooks.Text = string.Format("{0} Books", _boks.Count);
            }
            else
            {
                MessageBox.Show("Ouch!, Can't find main.mdb");
            }
        }

        private void RefreshData()
        {
            if (Directory.Exists(edtRootPath.Text))
            {
                
                string[] files = Directory.GetFiles(edtRootPath.Text, "*.mdb", SearchOption.AllDirectories);

                _files.Clear();
                _archives.Clear();
                _archivesFiles.Clear();
                foreach (string file in files)
                {
                    // Never used indices list this prone to crash
                    if (file.ToLower().Contains("indices") == false)
                    {
                        if (file.ToLower().Contains("archive") == true)
                        {
                            _archives.Add(file);
                            _archivesFiles.Add(Path.GetFileName(file));
                        }
                        else
                        {
                            _files.Add(file);
                        }
                    }
                }

                UpdateFiles();
                UpdateBooks();
            }
        }

        private void btnBrowse_Click(object sender, EventArgs e)
        {
            dlgFolderBrowse.Description = "Select the Root Path of Shamela Library";
            if (dlgFolderBrowse.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                edtRootPath.Text = dlgFolderBrowse.SelectedPath;
                if (edtiShamelaTargetPath.Text.Trim().Length == 0)
                {
                    edtiShamelaTargetPath.Text = edtRootPath.Text;
                }

                RefreshData();
            }
        }

        BackgroundWorker _activeWorker = null;


        private void Convert(List<BokTable> tables)
        {
            if (tables.Count < 1)
            {
                MessageBox.Show("Please select at least 1 book to convert, or click Convert All", "Warning!", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }

            btnConvertSel.Enabled = false;
            btnConvertAll.Enabled = false;
            btnStop.Enabled = true;

            string targetPath = edtiShamelaTargetPath.Text;
            if (Directory.Exists(targetPath) == false)
            {
                Directory.CreateDirectory(targetPath);
            }

            Directory.SetCurrentDirectory(targetPath);

            _activeWorker = new BackgroundWorker();
            _activeWorker.WorkerReportsProgress = true;
            _activeWorker.WorkerSupportsCancellation = true;           

            ProgressState state = new ProgressState();

            _activeWorker.DoWork += delegate(object sender, DoWorkEventArgs e)
            {

                RSSGenerator rssGen = new RSSGenerator();

                if (_activeWorker.CancellationPending)
                {
                    e.Cancel = true;
                }

                state.BookMaximum = tables.Count;

                foreach (BokTable table in tables)
                {
                    long bkid = table.BkId;
                    string bk = table.Bk;
                    long archive = table.Archive;

                    state.BookCounter++;
                    state.CurrentBook = bk;

                    DbSqlite sqlite = new DbSqlite();
                    string fname = string.Format("{0}.aza", bk);
                    fname = fname.Replace('=', '-');
                    fname = fname.Replace(':', '-');

                    string azaPrefixName = string.Format("{0}", bkid);
                    string azaName = string.Format("{0}.aza", bkid);


                    if (sqlite.Connect(Path.Combine(targetPath, azaName)) == false)
                    {
                        // TODO
                    }

                    string query = DbSqlite.CreateMainTableDefinition();
                    sqlite.Query(query);

                    sqlite.CreateMainTable(table);

                    if (archive == 0)   // Books are not stored in archive
                    {
                        string dbName = string.Format("{0}.mdb", bkid);

                        if (_mdbs.Contains(dbName))
                        {
                            int index = _mdbs.IndexOf(dbName);
                            string filename = _files[index];

                            // Connect to the book database
                            DbJet db = new DbJet();
                            db.Connect(filename);

                            // Get max records
                            int bookRowCount = db.QueryScalar("select count(*) from book");
                            int titleRowCount = db.QueryScalar("select count(*) from title");

                            // Query the book
                            OleDbDataReader reader = db.Read("select * from book");

                            // Create table query string
                            query = DbSqlite.CreateTableDefinition(string.Format("b{0}", bkid), DbJet.GetDataTypes(reader));

                            // Create book table
                            sqlite.Query(query);

                            int recno = 1;

                            state.RecordMaximum = bookRowCount + titleRowCount;
                            state.RecordState = "Book Contents";

                            // Now Convert all the records
                            while (reader.Read())
                            {
                                string fieldnames = DbJet.GetDataFieldNames(reader);
                                string fieldvalues = DbJet.GetDataFieldValues(reader);
                                query = DbSqlite.InsertTableDefinition(string.Format("b{0}", bkid), fieldnames, fieldvalues);

                                sqlite.Query(query);

                                state.RecordCounter = recno++;

                                _activeWorker.ReportProgress(recno, state);
                            }

                            reader.Close();

                            state.RecordState = "Table Of Contents";

                            reader = db.Read("select * from title");
                            query = DbSqlite.CreateTableDefinition(string.Format("t{0}", bkid), DbJet.GetDataTypes(reader));

                            sqlite.Query(query);

                            // Now Convert all the records
                            while (reader.Read())
                            {
                                string fieldnames = DbJet.GetDataFieldNames(reader);
                                string fieldvalues = DbJet.GetDataFieldValues(reader);
                                query = DbSqlite.InsertTableDefinition(string.Format("t{0}", bkid), fieldnames, fieldvalues);

                                sqlite.Query(query);

                                state.RecordCounter = recno++;

                                _activeWorker.ReportProgress(recno, state);
                            }

                            reader.Close();
                        }

                    }
                    else  // If books stored as an archive
                    {
                        string dbName = string.Format("{0}.mdb", archive);

                        if (_archivesFiles.Contains(dbName))//_archives.Contains(dbName))
                        {
                            int index = _archivesFiles.IndexOf(dbName);
                            string filename = _archives[index];

                            // Connect to the book database
                            DbJet db = new DbJet();
                            db.Connect(filename);

                            // Get max records
                            int bookRowCount = db.QueryScalar(string.Format("SELECT COUNT(*) FROM b{0}", bkid));
                            int titleRowCount = db.QueryScalar(string.Format("select count(*) from t{0}", bkid));

                            // Query the book
                            OleDbDataReader reader = db.Read(string.Format("select * from b{0}", bkid));

                            // Create table query string
                            query = DbSqlite.CreateTableDefinition(string.Format("b{0}", bkid), DbJet.GetDataTypes(reader));

                            // Create book table
                            sqlite.Query(query);

                            int recno = 1;

                            state.RecordMaximum = bookRowCount + titleRowCount;
                            state.RecordState = "Book Contents";

                            // Now Convert all the records
                            while (reader.Read())
                            {
                                string fieldnames = DbJet.GetDataFieldNames(reader);
                                string fieldvalues = DbJet.GetDataFieldValues(reader);
                                query = DbSqlite.InsertTableDefinition(string.Format("b{0}", bkid), fieldnames, fieldvalues);

                                sqlite.Query(query);

                                state.RecordCounter = recno++;

                                _activeWorker.ReportProgress(recno, state);
                            }

                            reader.Close();

                            state.RecordState = "Table Of Contents";

                            reader = db.Read(string.Format("select * from t{0}", bkid));
                            query = DbSqlite.CreateTableDefinition(string.Format("t{0}", bkid), DbJet.GetDataTypes(reader));

                            sqlite.Query(query);

                            // Now Convert all the records
                            while (reader.Read())
                            {
                                string fieldnames = DbJet.GetDataFieldNames(reader);
                                string fieldvalues = DbJet.GetDataFieldValues(reader);
                                query = DbSqlite.InsertTableDefinition(string.Format("t{0}", bkid), fieldnames, fieldvalues);

                                sqlite.Query(query);

                                state.RecordCounter = recno++;

                                _activeWorker.ReportProgress(recno, state);
                            }

                            reader.Close();
                        }
                    }

                    sqlite.Disconnect();

                    Manifest manifest = new Manifest();
                    manifest.Title = bk;
                    manifest.Author = table.AuthInf;
                    manifest.Category = table.Cat;
                    manifest.Link = azaName;

                    string plist = Plist.PlistDocument.CreateDocument(manifest);
                    string manifestName = Path.Combine(targetPath, "Manifest.plist");
                    StreamWriter writer = new StreamWriter(manifestName);
                    writer.Write(plist);
                    writer.Flush();
                    writer.Close();
                    
                                        
                    RSSItem rssItem = rssGen.AddItem();
                    rssItem.Title = table.BkId.ToString();
                    rssItem.PubDate = DateTime.Now;
                    rssItem.Link = string.Format("{0}.azx", azaPrefixName);
                    rssItem.Author = table.AuthInf;
                    rssItem.Description = table.Bk;

                    using (ZipFile zip = new ZipFile())
                    {

                        string zipName = azaName;// Path.Combine(targetPath, azaName);

                        try
                        {
                            zip.AddFile(zipName);
                            zip.AddFile("Manifest.plist");
                            zip.Save(string.Format("{0}.azx", azaPrefixName));
                        }
                        finally
                        {
                            File.Delete(zipName);
                            File.Delete(manifestName);
                        }
                    }
                }

                rssGen.FeedXML(string.Format("Books-{0}.rss", DateTime.Now));
            };

            _activeWorker.ProgressChanged += delegate(object sender, ProgressChangedEventArgs e)
            {
                ProgressState ps = e.UserState as ProgressState;
                if (ps.BookCounter > ps.BookMaximum)
                {
                    ps.BookCounter = ps.BookMaximum;
                }

                pbBooks.Value = ps.BookCounter;
                pbBooks.Maximum = ps.BookMaximum;
                pbBooks.Minimum = ps.BookMinimum;
                lblBookStatus.Text = string.Format("Book {0} of {1} : {2}", ps.BookCounter, ps.BookMaximum, ps.CurrentBook);

                if (ps.RecordCounter > ps.RecordMaximum)
                {
                    ps.RecordCounter = ps.RecordMaximum;
                }
                pbRecords.Value = ps.RecordCounter;
                pbRecords.Maximum = ps.RecordMaximum;
                pbRecords.Minimum = ps.RecordMinimum;
                lblRecordStatus.Text = string.Format("Processing {0}: Record {1} of {2}", ps.RecordState, ps.RecordCounter, ps.RecordMaximum);
            };

            _activeWorker.RunWorkerCompleted += delegate(object sender, RunWorkerCompletedEventArgs e)
            {
                if (e.Cancelled)
                {
                    MessageBox.Show("Convert Canceled", "iShamela", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    MessageBox.Show("Convert Completed", "iShamela", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }

                btnConvertSel.Enabled = true;
                btnConvertAll.Enabled = true;
                btnStop.Enabled = false;
                _activeWorker = null;
                pbBooks.Value = 0;
                pbRecords.Value = 0;
                lblBookStatus.Text = "Ready";
                lblRecordStatus.Text = "Ready";
            };

            _activeWorker.RunWorkerAsync();
        }

        private List<BokTable> GetSelectionTables()
        {
            List<BokTable> tables = new List<BokTable>();
            for (int i = 0; i < listBooks.Items.Count; i++)
            {
                if (listBooks.GetSelected(i) == true)
                {
                    tables.Add(_boks[i]);
                }
            }

            return tables;
        }

        private void btnStart_Click(object sender, EventArgs e)
        {
            List<BokTable> tables = GetSelectionTables();

            Convert(tables);
        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            RefreshData();
        }

        private void btnSelectAll_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < listBooks.Items.Count; i++)
            {
                listBooks.SetSelected(i, true);
            }
        }

        private void btnClearAll_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < listBooks.Items.Count; i++)
            {
                listBooks.SetSelected(i, false);
            }
        }

        private void btnStop_Click(object sender, EventArgs e)
        {
            if (_activeWorker != null)
            {
                _activeWorker.CancelAsync();
            }
        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (_activeWorker != null)
            {
                if (MessageBox.Show("Book Conversion is in progress!\nAre you sure you want to exit?", "Warning!", MessageBoxButtons.YesNo, MessageBoxIcon.Information) == System.Windows.Forms.DialogResult.No)
                {
                    e.Cancel = true;
                }
            }
        }

        private void btnConvertAll_Click(object sender, EventArgs e)
        {
            Convert(_boks);
        }

        private void btnBrowsePath_Click(object sender, EventArgs e)
        {
            dlgFolderBrowse.Description = "Select the Target Path of iShamela Library";
            if (dlgFolderBrowse.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                edtiShamelaTargetPath.Text = dlgFolderBrowse.SelectedPath;
            }

        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            /*
            RSSGenerator rss = new RSSGenerator();
            RSSItem item = rss.AddItem();
            item.Title = "test";
            item.Description = "Aqeedah";
            item.Author = "Ibn Othaymen";
            item.PubDate = DateTime.Now;
            item.Link = "21.aza";

            rss.FeedXML("e:\\test.xml");
             */
        }

        private void btnCatalogGenerator_Click(object sender, EventArgs e)
        {
            if (_files.Count < 1)
            {
                return;
            }

            string targetPath = edtiShamelaTargetPath.Text;
            if (Directory.Exists(targetPath) == false)
            {
                Directory.CreateDirectory(targetPath);
            }

            Directory.SetCurrentDirectory(targetPath);

            string dbName = "main.mdb";

            if (_mdbs.Contains(dbName))
            {
                int index = _mdbs.IndexOf(dbName);
                string maindb = _files[index];

                if (File.Exists(maindb))
                {

                    DbJet jet = new DbJet();
                    jet.Connect(maindb);

                    List<CatTable> cats = CatTable.Fill(jet);

                    jet.Disconnect();

                    string plist = Plist.PlistDocument.CreateDocument(cats);

                    string catName = Path.Combine(targetPath, "Categories.plist");
                    StreamWriter writer = new StreamWriter(catName);
                    writer.Write(plist);
                    writer.Flush();
                    writer.Close();

                    MessageBox.Show("Categories generated!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }

            }

            
        }
    }
}
