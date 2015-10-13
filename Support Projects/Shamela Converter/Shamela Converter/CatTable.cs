using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OleDb;

namespace iShamela
{
    [Serializable]
    public class CatTable
    {
        public CatTable()
        {
            id = 0;
            name = "";
            catord = 0;
            lvl = 0;
        }

        public static Dictionary<long, CatTable> GenerateIdMap(List<CatTable> tables)
        {
            Dictionary<long, CatTable> map = new Dictionary<long, CatTable>();
            foreach (CatTable cat in tables)
            {
                map.Add(cat.id, cat);
            }
            return map;
        }

        public static List<CatTable> Fill(DbJet db)
        {
            OleDbDataReader reader = db.Read("select * from 0cat order by catord asc");

            List<CatTable> tables = new List<CatTable>();
            Dictionary<string, object> fields = new Dictionary<string, object>();

            while (reader.Read())
            {
                // Fields will help us to overcome non seq order
                fields.Clear();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    fields.Add(reader.GetName(i).ToLower(), reader.GetValue(i));
                }

                CatTable table = new CatTable();
                table.id = long.Parse(fields["id"].ToString());
                table.name = fields["name"].ToString();
                table.catord = long.Parse(fields["catord"].ToString());
                table.lvl = long.Parse(fields["lvl"].ToString());

                tables.Add(table);
            }

            return tables;
        }

        public long id { get; set; }
        public string name { get; set; }
        public long catord { get; set; }
        public long lvl { get; set; }
    }
}
