using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace iShamela.DataType
{
    public class VarChar : IDataType
    {
        public string var;
        public VarChar(string fieldName, int num)
        {
            var = fieldName + " VARCHAR(" + num.ToString() + ")";
        }

        #region IDataType Members

        public string AsString()
        {
            return var;
        }

        #endregion
    }
}
