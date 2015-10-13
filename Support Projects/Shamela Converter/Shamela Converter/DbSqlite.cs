using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SQLite;
using iShamela.DataType;
using System.Diagnostics;
using System.Windows.Forms;
using System.IO;

namespace iShamela
{
    public class DbSqlite
    {
        SQLiteConnection _sqlCon;

        public DbSqlite()
        {
            _sqlCon = new SQLiteConnection();
        }

        public static string CreateDataTypesDefinition(IDataType[] vars)
        {
            string dt = "";
            for (int i = 0; i < vars.Count(); i++)
            {
                IDataType dataType = vars[i];
                dt = dt + dataType.AsString();
                if (i < vars.Count() - 1)
                {
                    dt = dt + ", ";
                }
            }

            return dt;
        }

        public static string CreateTableDefinition(string tableName, IDataType[] vars)
        {
            string query = "CREATE TABLE IF NOT EXISTS " + tableName;

            return string.Format("{0} ({1});", query, CreateDataTypesDefinition(vars));
        }

        public static string CreateMainTableDefinition()
        {
            IDataType[] types = {   new Number("BkId"), 
                                    new VarChar("Bk", 1000), 
                                    new VarChar("Betaka", 1000),
                                    new VarChar("Inf", 1000),
                                    new VarChar("Auth", 1000),
                                    new VarChar("AuthInf", 1000),
                                    new VarChar("TafseerNam", 1000),
                                    new Number("IslamShort"),
                                    new Number("oNum"),
                                    new Number("oVer"),
                                    new VarChar("seal", 100),
                                    new Number("oAuth"),
                                    new Number("bVer"),
                                    new Number("Pdf"),
                                    new Number("oAuthVer"),
                                    new VarChar("verName", 1000), 
                                    new VarChar("cat", 1000),
                                    new VarChar("Lng", 1000),
                                    new VarChar("HigriD", 1000),
                                    new Number("AD"),
                                    new VarChar("aSeal", 1000),
                                    new VarChar("bLnk", 1000),
                                    new Number("PdfCs"),
                                    new Number("ShrtCs")
                                };

            return CreateTableDefinition("Main", types);
        }

        public static string InsertTableDefinition(string tableName, string fields, string values)
        {
            return string.Format("INSERT INTO {0}({1}) VALUES ({2});", tableName, fields, values);
        }

        public bool Connect(string filename)
        {
           // SQLiteConnection.CreateFile(filename);

            if (File.Exists(filename))
            {
                File.Delete(filename);
            }

            try
            {
                _sqlCon = new SQLiteConnection(string.Format("Data Source={0}", filename));
                _sqlCon.Open();
            }
            catch (Exception)
            {
                return false;
            }

            return true;
        }

        public void Disconnect()
        {
            Debug.Assert(_sqlCon != null);

            _sqlCon.Close();
        }

        public int Query(string query)
        {
            Debug.Assert(_sqlCon != null);

            SQLiteCommand comm = new SQLiteCommand(query, _sqlCon);

            int result = -1;
            try
            {
                result = comm.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Query: Fatal Error!", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            return result;
        }

        public void CreateMainTable(BokTable table)
        {
            string query = InsertTableDefinition("Main",
                "BkId, Bk, Betaka, Inf, Auth, AuthInf, IslamShort, TafseerNam, Cat", string.Format("\"{0}\", \"{1}\", \"{2}\", \"{3}\", \"{4}\", \"{5}\", \"{6}\", \"{7}\", \"{8}\"",
                table.BkId, table.Bk, table.Betaka, table.Inf, table.Auth, table.AuthInf, table.IslamShort, table.TafseerNam, table.Cat));

            Query(query);
        }

        public void Convert(string filename, BokTable table)
        {
        }

    }
}
