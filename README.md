ABExample
=========

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

This ABExample reads the users AddressBook, and then displays them. You can delete Contacts from this App
but they will not be deleted from the users AddressBook. This ABExample will work for a user which has 
a large number of Contacts in excess of 20K or more.

Uses ABContact which works with ARC and makes reading the iPhone AddressBook easy.

Uses AppIOS submodule which has SQLite infrastructure for accessing an SQLite database.

This App has built in Crash Logs using the NSException+Category which is used in main.m. When a crash 
occurs the fully symbolicated stack trace will be written into the CrashData table. When the App then
resumes again after the crash, this table is checked for new entries in the AppDelete : uploadCrashData.
This method would then send the crash data to the Server.

This App also supports incremental upgrades to the database via the AppInfo Table and it's version
identifier. The upgradeDB:(double)dbVersion method will check for the current version, and perform
SQL alter table commands to upgrade the existing DB to the latest version.

In addition this App incorporates Google Analytics, you will need to set your own AnalyticsIdentifier in
the DBExample-Info.plist.

Note : In the DBExample Xcode project : Build Phases, there is a Run Script that has two lines commented
out. These lines add a GitCommit and BuildDate to the App and are stored within the App. An initial build
will have issues with this script, but once it's built once it should work fine there after so you can then
comment these lines in the Run Script back in. Now your App will be able to display it's GitCommit, and
BuildDate in the App, and this information is also incorporated into the Crash Logs which can be uploaded
to a Server.
