# NYBestsellers
<img src="https://github.com/elefantel/NYBestsellers/blob/master/Screenshots/categories.png" alt="Categories" style="width: 200px;"/>
<img src="https://github.com/elefantel/NYBestsellers/blob/master/Screenshots/rankings.png" alt="Rankings" style="width: 200px;"/>
<img src="https://github.com/elefantel/NYBestsellers/blob/master/Screenshots/book-profile.png" alt="Book Profile" style="width: 200px;"/>
<img src="https://github.com/elefantel/NYBestsellers/blob/master/Screenshots/bookmarks.png" alt="Bookmarks" style="width: 200px;"/>
## Description
This is an iOS app that fetches the latest books bestseller profiles from the New York Times Books RESTful API. It stores the results locally on the client in Core Data, which can be viewed when offline. It offers an option to select a books category from 24 different categories ranked per category. The book profiles are displayed by rank and they show the book title, author and the book image. Selecting a book takes you to a view that shows all the information about that book. 

The app also provides a bookmarking/favoriting and search features. You can bookmark or remove bookmark on a book by tapping the book profile picture, and bookmarks are added to the bookmarks tab. You can also search a book by title, author and description.

Images are downloaded once and cached locally to significantly improve the response of the tableviews.

## Dependencies
This app depends on the following open source libraries:

1. **AFNetworking** - A networking framework for iOS, OS X, watchOS, and tvOS.

2. **RestKit**- A modern Objective-C framework for implementing RESTful web services clients on iOS and Mac OS X.

3. **SDWebImage** - An asynchronous image downloader with cache support as a UIImageView category.

4. **SOCKit** - A String <-> Object Coding for Objective-C that transform objects into strings and vice versa.

5. **TransitionKit** - An Objective-C block based API for implementing State Machines.

## Licence
NYBestsellers is licensed under the terms of the <a href="https://en.wikipedia.org/wiki/MIT_License">MIT License</a>. Please see LICENSE file for full details.
