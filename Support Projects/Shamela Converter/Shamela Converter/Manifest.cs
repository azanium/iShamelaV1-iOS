using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace iShamela
{
    [Serializable]
    public class Manifest
    {
        public string Title { get; set; }
        public string Author { get; set; }
        public long Category { get; set; }
        public string Link { get; set; }
    }
}
