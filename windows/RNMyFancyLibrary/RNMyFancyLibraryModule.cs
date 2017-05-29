using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Com.Reactlibrary.RNMyFancyLibrary
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNMyFancyLibraryModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNMyFancyLibraryModule"/>.
        /// </summary>
        internal RNMyFancyLibraryModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNMyFancyLibrary";
            }
        }
    }
}
