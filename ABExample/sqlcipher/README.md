SQLCipher
======

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

To use SQLCipher get the library from Zetetic
https://www.zetetic.net/sqlcipher/
It costs $499 for a license, and $99 a year for support which is very recommended.
Once you have the library, place the binaries in this directory.
ABExample/sqlcipher/binaries
libsqlcipher-ios.a
ABExample/sqlcipher/include
sqlite3.h

Now in the Xcode Project ABExample do the following on the  target
On the Xcode Target Project
Search Paths
Header Search Paths 
"$(SRCROOT)/ABExample/sqlcipher/include/sqlite3.h"

Apple LLVM 8.0 - Custom Compiler Flags
Other C Flags
Debug : -DSQLITE_HAS_CODEC
Release : -DSQLITE_HAS_CODEC

Apple LLVM 8.0 - Preprocessing
Preprocessor Macros
Debug : ENCRYPT
Release : ENCRYPT

Now drag and drop the libsqlcipher-ios.a into the Frameworks directory, 
and delete libsqlite3.0.dylib since it replaces it.

This will enable the preprocessor ENCRYPT flag, and the Contacts.db will now be encrypted.
There are other methods to decrypt an encrypted DB back to plain text in DataAccess, but 
the encryption keys have to be known to do this.

