using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Data.OleDb;

namespace iShamela
{
    public class BokTable
    {
        public BokTable()
        {
            BkId = 0;
            Bk = "";
            Cat = 0;
            Betaka = "";
            Inf = "";
            Auth = "";
            AuthInf = "";
            IslamShort = 0;
            TafseerNam = "";
            Idx = 0;

            AuthNo = 0;
            BookOrd = 0;
            Max = 0;
            NoSr = 0;
            Comp = 0;
            Archive = 0;
            Iso = "";
        }

        public static Dictionary<string, BokTable> GenerateStringMap(List<BokTable> tables)
        {
            Dictionary<string, BokTable> map = new Dictionary<string, BokTable>();
            foreach (BokTable bok in tables)
            {
                map.Add(bok.Bk, bok);
            }
            return map;
        }

        public static Dictionary<long, BokTable> GenerateIdMap(List<BokTable> tables)
        {
            Dictionary<long, BokTable> map = new Dictionary<long, BokTable>();
            foreach (BokTable bok in tables)
            {
                map.Add(bok.BkId, bok);
            }
            return map;
        }

        public static List<BokTable> Fill(DbJet db)
        {
            List<BokTable> tables = new List<BokTable>();

            OleDbDataReader reader = db.Read("select * from 0bok");

            Dictionary<string, object> fields = new Dictionary<string, object>();

            while (reader.Read())
            {
                fields.Clear();
                for (int i = 0; i < reader.FieldCount; i++)
                {
                    fields.Add(reader.GetName(i).ToLower(), reader.GetValue(i));
                }

                BokTable table = new BokTable();

                table.BkId = Converter.AsLong(fields["bkid"]);
                table.Bk = Converter.AsString(fields["bk"]);
                table.Cat = Converter.AsLong(fields["cat"]);
                table.Betaka = Converter.AsString(fields["betaka"]);
                table.Inf = Converter.AsString(fields["inf"]);
                table.BookOrd = Converter.AsLong(fields["bkord"]);
                table.AuthNo = Converter.AsLong(fields["authno"]);
                table.AuthInf = Converter.AsString(fields["authinf"]);
                table.Auth = Converter.AsString(fields["auth"]);
                table.Max = Converter.AsLong(fields["max"]);
                table.NoSr = Converter.AsLong(fields["nosr"]);
                table.Comp = Converter.AsLong(fields["comp"]);
                table.IslamShort = Converter.AsLong(fields["islamshort"]);
                table.TafseerNam = Converter.AsString(fields["tafseernam"]);
                table.Idx = Converter.AsLong(fields["idx"]);
                table.Archive = Converter.AsLong(fields["archive"]);
                table.Iso = Converter.AsString(fields["iso"]);

                tables.Add(table);
            }




            return tables;
        }

        public long BkId { get; set; }
        private string _bk = "";
        public string Bk
        {
            get { return DbJet.ReplaceMarks(_bk); }
            set { _bk = value; }
        }

        public long Cat { get; set; }

        private string _betaka = "";
        public string Betaka 
        {
            get { return DbJet.ReplaceMarks(_betaka); }
            set { _betaka = value; }
        }

        private string _inf = "";
        public string Inf 
        { 
            get { return DbJet.ReplaceMarks(_inf);  }
            set { _inf = value; }
        }
        public long BookOrd { get; set; }
        public long AuthNo { get; set; }

        private string _auth = "";
        public string Auth 
        {
            get { return DbJet.ReplaceMarks(_auth); }
            set { _auth = value; }
        }

        private string _authInf = "";
        public string AuthInf 
        {
            get { return DbJet.ReplaceMarks(_authInf); }
            set { _authInf = value; }
        }
        public long Max { get; set; }
        public long NoSr { get; set; }
        public long Comp { get; set; }
        public long IslamShort { get; set; }

        private string _tafseerNam = "";
        public string TafseerNam 
        {
            get { return DbJet.ReplaceMarks(_tafseerNam); }
            set { _tafseerNam = value; }
        }
        public long Idx { get; set; }
        public long Archive { get; set; }

        private string _iso = "";
        public string Iso 
        { 
            get { return DbJet.ReplaceMarks(_iso); } 
            set { _iso = value; } 
        }

    }
}
