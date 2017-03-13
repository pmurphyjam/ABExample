ABExample
=========

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

This Application uses CocoaPods, the Podfile is located in the main directory.

    use_frameworks!
    target "ABExample" do
    pod "SQLDataAccess"
    end
    
You must install CocoaPods, and then run the command in the terminal window in the ABExample directory:

    >pod install;
    >pod update;

The Podfile will install Google Analytics and SQLDataAccess which performs all of your database accesses to the
Contacts.db database using SQLite. The SQLDataAccess class uses the SQLite library libsqlite3.tbd.

Once the Pod is complete, now load the ABExample.xcworkspace in Xcode. 
This App was built with Xcode 8.2.1, and is designed to run in iOS10.2+.

To run the App just hit the Run command in Xcode, the App should ask you for permissions to read your Contacts, and
Calendar. All the App does is store these in the Contacts.db, and it never updates your Contacts or Calendar, it just
reads them for demo purposes.

ABExample reads the users AddressBook, and then displays them. You can delete Contacts from this App
but they will not be deleted from the users AddressBook. This ABExample will work for a user which has 
a large number of Contacts in excess of 20K or more. The Contacts Table View supports alpha section headers, 
deleting, updating, indexing for quick scrolling, and searching using a UISearchDisplayController for 
searching first and last name. In addition the App displays the users current Calendar Events, and displays
events that have attendees, and are not all day events.

In the ViewControllers directory there are two Models that control all the SQL statements into the Contacts.db
using the SQLDataAccess class.
ContactModel - Writes and reads the users Contacts from the Contacts.db.
CalendarModel - Writes and reads the users Calendar from the Contacts.db.
These models show you how to write your SQL queries using SQLDataAccess.
SQLDataAccess makes writing SQL statements super simple, and if you made a mistake in your SQL query it will print
out an error message giving you the SQLite error message.

The ABConstants has some defines in it for Notifications.
The SQLDataAccess : AppConstants has a DB_FILE and DB_FILEX define it which you can reassign in your
AppDelegate.m so SQLDataAccess can find your database which must be located in the NSBundle.
The Category SettingsModel+Category is an extension of the SQLDataAccess : SettingsModel, this uses
NSUserDefaults to store all your register data for the App. If you're using SQLCipher the encryption register
[SettingsModel setDBPW0:] is used to set the Encryption key into SQLCipher. The SQLDataAccess.m class has
lots of comments in it for how to setup SQLCipher.

In addition this App incorporates Google Analytics, you will need to set your own AnalyticsIdentifier in
the ABExample-Info.plist.

Note : In the ABExample Xcode project : Build Phases, there is a Run Script that creates your GitCommit,
and BuildDate and these are stored in the SettingsModel.

