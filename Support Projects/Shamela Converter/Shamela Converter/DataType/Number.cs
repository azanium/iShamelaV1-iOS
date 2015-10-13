using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace iShamela.DataType
{
    public class Number : IDataType
    {
        #region IDataType Members

        private string var;
        public string AsString()
        {
            return var;
        }

        #endregion

        public Number(string fieldName)
        {
            var = fieldName + " NUMBER";
        }

        public Number(string fieldName, long defaultNum)
        {
            var = fieldName + " NUMBER DEFAULT " + defaultNum.ToString();
        }
    }
}
