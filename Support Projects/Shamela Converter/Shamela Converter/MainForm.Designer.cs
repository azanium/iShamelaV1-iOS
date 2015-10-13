namespace iShamela
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.label1 = new System.Windows.Forms.Label();
            this.edtRootPath = new System.Windows.Forms.TextBox();
            this.btnBrowse = new System.Windows.Forms.Button();
            this.btnConvertSel = new System.Windows.Forms.Button();
            this.dlgFolderBrowse = new System.Windows.Forms.FolderBrowserDialog();
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.listFiles = new System.Windows.Forms.ListBox();
            this.listBooks = new System.Windows.Forms.ListBox();
            this.btnRefresh = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.lblBooks = new System.Windows.Forms.Label();
            this.btnSelectAll = new System.Windows.Forms.Button();
            this.pbBooks = new System.Windows.Forms.ProgressBar();
            this.pbRecords = new System.Windows.Forms.ProgressBar();
            this.lblBookStatus = new System.Windows.Forms.Label();
            this.lblRecordStatus = new System.Windows.Forms.Label();
            this.btnClearAll = new System.Windows.Forms.Button();
            this.btnConvertAll = new System.Windows.Forms.Button();
            this.btnBrowsePath = new System.Windows.Forms.Button();
            this.edtiShamelaTargetPath = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.btnStop = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.btnCatalogGenerator = new System.Windows.Forms.Button();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(23, 26);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(98, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Shamela Root Path";
            // 
            // edtRootPath
            // 
            this.edtRootPath.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.edtRootPath.Location = new System.Drawing.Point(138, 23);
            this.edtRootPath.Name = "edtRootPath";
            this.edtRootPath.Size = new System.Drawing.Size(534, 20);
            this.edtRootPath.TabIndex = 0;
            // 
            // btnBrowse
            // 
            this.btnBrowse.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnBrowse.Location = new System.Drawing.Point(679, 21);
            this.btnBrowse.Name = "btnBrowse";
            this.btnBrowse.Size = new System.Drawing.Size(34, 23);
            this.btnBrowse.TabIndex = 2;
            this.btnBrowse.Text = "...";
            this.btnBrowse.UseVisualStyleBackColor = true;
            this.btnBrowse.Click += new System.EventHandler(this.btnBrowse_Click);
            // 
            // btnConvertSel
            // 
            this.btnConvertSel.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnConvertSel.Location = new System.Drawing.Point(719, 175);
            this.btnConvertSel.Name = "btnConvertSel";
            this.btnConvertSel.Size = new System.Drawing.Size(89, 23);
            this.btnConvertSel.TabIndex = 9;
            this.btnConvertSel.Text = "Convert Sel";
            this.btnConvertSel.UseVisualStyleBackColor = true;
            this.btnConvertSel.Click += new System.EventHandler(this.btnStart_Click);
            // 
            // splitContainer1
            // 
            this.splitContainer1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.splitContainer1.Location = new System.Drawing.Point(26, 104);
            this.splitContainer1.Name = "splitContainer1";
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.listFiles);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.Controls.Add(this.listBooks);
            this.splitContainer1.Size = new System.Drawing.Size(685, 259);
            this.splitContainer1.SplitterDistance = 282;
            this.splitContainer1.TabIndex = 6;
            // 
            // listFiles
            // 
            this.listFiles.Dock = System.Windows.Forms.DockStyle.Fill;
            this.listFiles.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.listFiles.FormattingEnabled = true;
            this.listFiles.ItemHeight = 16;
            this.listFiles.Location = new System.Drawing.Point(0, 0);
            this.listFiles.Name = "listFiles";
            this.listFiles.Size = new System.Drawing.Size(282, 259);
            this.listFiles.TabIndex = 5;
            // 
            // listBooks
            // 
            this.listBooks.Dock = System.Windows.Forms.DockStyle.Fill;
            this.listBooks.Font = new System.Drawing.Font("Tahoma", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.listBooks.FormattingEnabled = true;
            this.listBooks.ItemHeight = 16;
            this.listBooks.Location = new System.Drawing.Point(0, 0);
            this.listBooks.Name = "listBooks";
            this.listBooks.RightToLeft = System.Windows.Forms.RightToLeft.Yes;
            this.listBooks.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended;
            this.listBooks.Size = new System.Drawing.Size(399, 259);
            this.listBooks.TabIndex = 6;
            // 
            // btnRefresh
            // 
            this.btnRefresh.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnRefresh.Location = new System.Drawing.Point(719, 21);
            this.btnRefresh.Name = "btnRefresh";
            this.btnRefresh.Size = new System.Drawing.Size(87, 23);
            this.btnRefresh.TabIndex = 4;
            this.btnRefresh.Text = "Refresh";
            this.btnRefresh.UseVisualStyleBackColor = true;
            this.btnRefresh.Click += new System.EventHandler(this.btnRefresh_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(23, 85);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(28, 13);
            this.label2.TabIndex = 8;
            this.label2.Text = "Files";
            // 
            // lblBooks
            // 
            this.lblBooks.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.lblBooks.AutoSize = true;
            this.lblBooks.Location = new System.Drawing.Point(309, 85);
            this.lblBooks.Name = "lblBooks";
            this.lblBooks.Size = new System.Drawing.Size(35, 13);
            this.lblBooks.TabIndex = 9;
            this.lblBooks.Text = "Books";
            this.lblBooks.TextAlign = System.Drawing.ContentAlignment.TopRight;
            // 
            // btnSelectAll
            // 
            this.btnSelectAll.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnSelectAll.Location = new System.Drawing.Point(719, 104);
            this.btnSelectAll.Name = "btnSelectAll";
            this.btnSelectAll.Size = new System.Drawing.Size(89, 23);
            this.btnSelectAll.TabIndex = 7;
            this.btnSelectAll.Text = "Select All";
            this.btnSelectAll.UseVisualStyleBackColor = true;
            this.btnSelectAll.Click += new System.EventHandler(this.btnSelectAll_Click);
            // 
            // pbBooks
            // 
            this.pbBooks.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.pbBooks.Location = new System.Drawing.Point(26, 395);
            this.pbBooks.Name = "pbBooks";
            this.pbBooks.Size = new System.Drawing.Size(687, 21);
            this.pbBooks.TabIndex = 11;
            // 
            // pbRecords
            // 
            this.pbRecords.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.pbRecords.Location = new System.Drawing.Point(26, 443);
            this.pbRecords.Name = "pbRecords";
            this.pbRecords.Size = new System.Drawing.Size(687, 21);
            this.pbRecords.TabIndex = 12;
            // 
            // lblBookStatus
            // 
            this.lblBookStatus.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.lblBookStatus.AutoSize = true;
            this.lblBookStatus.Location = new System.Drawing.Point(23, 379);
            this.lblBookStatus.Name = "lblBookStatus";
            this.lblBookStatus.Size = new System.Drawing.Size(38, 13);
            this.lblBookStatus.TabIndex = 13;
            this.lblBookStatus.Text = "Ready";
            // 
            // lblRecordStatus
            // 
            this.lblRecordStatus.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.lblRecordStatus.AutoSize = true;
            this.lblRecordStatus.Location = new System.Drawing.Point(23, 427);
            this.lblRecordStatus.Name = "lblRecordStatus";
            this.lblRecordStatus.Size = new System.Drawing.Size(38, 13);
            this.lblRecordStatus.TabIndex = 14;
            this.lblRecordStatus.Text = "Ready";
            // 
            // btnClearAll
            // 
            this.btnClearAll.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnClearAll.Location = new System.Drawing.Point(719, 133);
            this.btnClearAll.Name = "btnClearAll";
            this.btnClearAll.Size = new System.Drawing.Size(89, 23);
            this.btnClearAll.TabIndex = 8;
            this.btnClearAll.Text = "Clear All";
            this.btnClearAll.UseVisualStyleBackColor = true;
            this.btnClearAll.Click += new System.EventHandler(this.btnClearAll_Click);
            // 
            // btnConvertAll
            // 
            this.btnConvertAll.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnConvertAll.Location = new System.Drawing.Point(719, 204);
            this.btnConvertAll.Name = "btnConvertAll";
            this.btnConvertAll.Size = new System.Drawing.Size(89, 23);
            this.btnConvertAll.TabIndex = 10;
            this.btnConvertAll.Text = "Convert All";
            this.btnConvertAll.UseVisualStyleBackColor = true;
            this.btnConvertAll.Click += new System.EventHandler(this.btnConvertAll_Click);
            // 
            // btnBrowsePath
            // 
            this.btnBrowsePath.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnBrowsePath.Location = new System.Drawing.Point(679, 47);
            this.btnBrowsePath.Name = "btnBrowsePath";
            this.btnBrowsePath.Size = new System.Drawing.Size(34, 23);
            this.btnBrowsePath.TabIndex = 3;
            this.btnBrowsePath.Text = "...";
            this.btnBrowsePath.UseVisualStyleBackColor = true;
            this.btnBrowsePath.Click += new System.EventHandler(this.btnBrowsePath_Click);
            // 
            // edtiShamelaTargetPath
            // 
            this.edtiShamelaTargetPath.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.edtiShamelaTargetPath.Location = new System.Drawing.Point(138, 49);
            this.edtiShamelaTargetPath.Name = "edtiShamelaTargetPath";
            this.edtiShamelaTargetPath.Size = new System.Drawing.Size(534, 20);
            this.edtiShamelaTargetPath.TabIndex = 1;
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(23, 52);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(109, 13);
            this.label6.TabIndex = 17;
            this.label6.Text = "iShamela Target Path";
            // 
            // btnStop
            // 
            this.btnStop.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnStop.Enabled = false;
            this.btnStop.Location = new System.Drawing.Point(719, 246);
            this.btnStop.Name = "btnStop";
            this.btnStop.Size = new System.Drawing.Size(89, 23);
            this.btnStop.TabIndex = 11;
            this.btnStop.Text = "Stop";
            this.btnStop.UseVisualStyleBackColor = true;
            this.btnStop.Click += new System.EventHandler(this.btnStop_Click);
            // 
            // label4
            // 
            this.label4.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.label4.AutoSize = true;
            this.label4.Enabled = false;
            this.label4.Location = new System.Drawing.Point(23, 484);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(184, 13);
            this.label4.TabIndex = 21;
            this.label4.Text = "Copyright (C) 2011 Suhendra Ahmad";
            // 
            // btnCatalogGenerator
            // 
            this.btnCatalogGenerator.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnCatalogGenerator.Location = new System.Drawing.Point(719, 291);
            this.btnCatalogGenerator.Name = "btnCatalogGenerator";
            this.btnCatalogGenerator.Size = new System.Drawing.Size(89, 39);
            this.btnCatalogGenerator.TabIndex = 22;
            this.btnCatalogGenerator.Text = "Generate Categories";
            this.btnCatalogGenerator.UseVisualStyleBackColor = true;
            this.btnCatalogGenerator.Click += new System.EventHandler(this.btnCatalogGenerator_Click);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(825, 506);
            this.Controls.Add(this.btnCatalogGenerator);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.btnStop);
            this.Controls.Add(this.btnBrowsePath);
            this.Controls.Add(this.edtiShamelaTargetPath);
            this.Controls.Add(this.label6);
            this.Controls.Add(this.btnConvertAll);
            this.Controls.Add(this.btnClearAll);
            this.Controls.Add(this.lblRecordStatus);
            this.Controls.Add(this.lblBookStatus);
            this.Controls.Add(this.pbRecords);
            this.Controls.Add(this.pbBooks);
            this.Controls.Add(this.btnSelectAll);
            this.Controls.Add(this.lblBooks);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.btnRefresh);
            this.Controls.Add(this.splitContainer1);
            this.Controls.Add(this.btnConvertSel);
            this.Controls.Add(this.btnBrowse);
            this.Controls.Add(this.edtRootPath);
            this.Controls.Add(this.label1);
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Shamela Converter";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MainForm_FormClosing);
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox edtRootPath;
        private System.Windows.Forms.Button btnBrowse;
        private System.Windows.Forms.Button btnConvertSel;
        private System.Windows.Forms.FolderBrowserDialog dlgFolderBrowse;
        private System.Windows.Forms.SplitContainer splitContainer1;
        private System.Windows.Forms.ListBox listFiles;
        private System.Windows.Forms.ListBox listBooks;
        private System.Windows.Forms.Button btnRefresh;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button btnSelectAll;
        private System.Windows.Forms.ProgressBar pbBooks;
        private System.Windows.Forms.ProgressBar pbRecords;
        private System.Windows.Forms.Label lblBookStatus;
        private System.Windows.Forms.Label lblRecordStatus;
        private System.Windows.Forms.Button btnClearAll;
        private System.Windows.Forms.Button btnConvertAll;
        private System.Windows.Forms.Button btnBrowsePath;
        private System.Windows.Forms.TextBox edtiShamelaTargetPath;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Button btnStop;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label lblBooks;
        private System.Windows.Forms.Button btnCatalogGenerator;
    }
}

