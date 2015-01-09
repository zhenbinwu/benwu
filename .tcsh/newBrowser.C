// ===========================================================================
// 
//       Filename:  newBrowser.C
// 
//    Description:  
// 
//        Version:  1.0
//        Created:  01/24/2014 01:42:53 PM
//       Revision:  none
//       Compiler:  g++
// 
//         Author:  Zhenbin Wu (benwu), benwu@fnal.gov
//        Company:  Baylor University, CDF@FNAL, CMS@LPC
// 
// ===========================================================================

void newBrowser()
{
  TString CheckCMSSW = gSystem->Getenv("CMSSW_BASE");
  if (! CheckCMSSW.IsNull())
  {
    gSystem->Load("libFWCoreFWLite.so");
    AutoLibraryLoader::enable();
    gSystem->Load("libDataFormatsFWLite.so");
  }

  gROOT->SetStyle ("Plain");
  gStyle->SetOptStat(111111);
  new TBrowser;
}
