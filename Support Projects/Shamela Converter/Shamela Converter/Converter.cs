using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace iShamela
{
    public class Converter
    {
        public static string AsString(object obj)
        {
            string output = "";
            try
            {
                output = obj.ToString();
            }
            catch (Exception)
            {
                // Catch here
            }

            return output;
        }

        public static long AsLong(object obj)
        {
            long output = 0;
            if (long.TryParse(obj.ToString(), out output))
            {
                return output;
            }

            return 0;
        }
    }
}
