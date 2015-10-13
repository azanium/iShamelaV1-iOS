using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OleDb;
using System.Windows.Forms;
using System.Diagnostics;
using System.Data;
using iShamela.DataType;

namespace iShamela
{
    public class DbJet
    {
        OleDbConnection _sqlCon;

        public static string BuildConnectionString(string filename)
        {
            return string.Format("Provider=Microsoft.Jet.OLEDB.4.0;Data Source={0}", filename);
        }

        public DbJet()
        {
            _sqlCon = new OleDbConnection();
        }

        public void Connect(string fileName)
        {
            if (System.IO.File.Exists(fileName) == false)
            {
                MessageBox.Show(string.Format("{0} not found", fileName));
                return;
            }

            try
            {
                _sqlCon.ConnectionString = BuildConnectionString(fileName);
                _sqlCon.Open();
            }
            catch (OleDbException ex)
            {
                MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        public void Disconnect()
        {
            if (_sqlCon == null)
            {
                return;
            }

            if (_sqlCon.State == System.Data.ConnectionState.Open)
            {
                _sqlCon.Close();
                
            }
        }

        public OleDbDataReader Read(string query)
        {
            Debug.Assert(_sqlCon != null);

            OleDbCommand command = new OleDbCommand(query, _sqlCon);
            
            return command.ExecuteReader();
        }

        public int Query(string query)
        {
            Debug.Assert(_sqlCon != null);

            OleDbCommand command = new OleDbCommand(query, _sqlCon);

            return command.ExecuteNonQuery();
        }

        public int QueryScalar(string query)
        {
            Debug.Assert(_sqlCon != null);

            OleDbCommand command = new OleDbCommand(query, _sqlCon);

            return int.Parse(command.ExecuteScalar().ToString());
        }

        public static IDataType[] GetDataTypes(OleDbDataReader reader)
        {
            List<IDataType> types = new List<IDataType>();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (reader.GetFieldType(i) == typeof(string))
                {
                    types.Add(new VarChar(reader.GetName(i), 1000));
                }
                else
                {
                    types.Add(new Number(reader.GetName(i)));
                }
            }

            return types.ToArray();
        }

        public static string GetDataFieldNames(OleDbDataReader reader)
        {
            string dt = "";
            for (int i = 0; i < reader.FieldCount; i++)
            {
                dt = dt + "'"+reader.GetName(i)+"'";
                if (i < reader.FieldCount - 1)
                {
                    dt = dt + ", ";
                }
            }
            return dt;
        }

        public static string ReplaceMarks(string what)
        {
            string outp = "";
            outp = what.Replace("\"", "\"\"");
            outp = outp.Replace("'", "''");
            /*for (int i = 0; i < what.Length; i++)
            {
                if (what[i].Equals('"') == false)
                {
                    outp = outp + what[i];
                }
                else
                {
                    outp = outp + "\"\"";
                }
                
            }*/

            return outp;
        }

        public static string GetDataFieldValues(OleDbDataReader reader)
        {
            string dt = "";
            for (int i = 0; i < reader.FieldCount; i++)
            {
                dt = dt + "'" + ReplaceMarks(reader.GetValue(i).ToString()) + "'";
                if (i < reader.FieldCount - 1)
                {
                    dt = dt + ", ";
                }
            }
            return dt;
        }
    }
}
