using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;

namespace iShamela
{
    public class RSSItem
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public string Author { get; set; }
        public DateTime PubDate { get; set; }
        public string Link { get; set; }
    }

    public class RSSGenerator
    {
        private List<RSSItem> _rssItems = new List<RSSItem>();
        public List<RSSItem> RSSItems
        {
            get { return _rssItems; }
        }

        public RSSGenerator()
        {
            Title = "iShamela Catalog";
            Description = "iShamela Mobile Library";
            Link = "http://www.ishamela.com";
        }

        public RSSItem AddItem()
        {
            RSSItem item = new RSSItem();
            _rssItems.Add(item);
            return item;
        }

        public string Title { get; set; }
        public string Description { get; set; }
        public string Link { get; set; }

        public void FeedXML(string filename)
        {
            string fname = filename.Replace('/', '-');
            fname = fname.Replace(':', '-');
            XmlTextWriter xml = new XmlTextWriter(fname, Encoding.UTF8);

            xml.WriteStartElement("rss");
            xml.WriteAttributeString("version", "2.0");

            xml.WriteStartElement("channel");

            xml.WriteElementString("title", Title);
            xml.WriteElementString("description", Description);
            xml.WriteElementString("link", Link);

            foreach (RSSItem item in _rssItems)
            {
                xml.WriteStartElement("item");

                xml.WriteElementString("title", item.Title);
                xml.WriteElementString("description", item.Description);
                xml.WriteElementString("author", item.Author);
                xml.WriteElementString("link", item.Link);
                xml.WriteElementString("pubDate", item.PubDate.ToString("r"));

                xml.WriteEndElement();
            }

            xml.WriteEndElement();

            xml.WriteEndElement();

            xml.Flush();
            xml.Close();
        }
    }
}
