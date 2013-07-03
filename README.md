MLTableAlert
===
**[MLTableAlert][1] is a block-based UIAlertView replacement which allows you to show table view in alerts for fast selection.**  
MLTableAlert is completely based on UIView and it isn't a custom subclass of UIAlertView. It supports ARC and is compatible with iOS SDK 5.0 or later.  
Here are some features:  

* **Block-based**, no more delegates required.
* **table** property to access to the table view.
* **completionBlock** property to configure actions which have to be performed when Cancel button is pressed
* **selectionBlock** property to configure actions which have to be performed when a row in table view is pressed
* Custom height settings
* **Landscape** e orientation support for iPad
* Table alert creation through _class_ or _init_ method
* Table view customization managed by blocks: style your cells as you want
* Beautiful animations
* UIAlertView-like interface
* **Retina ready** and compatible with iPhone, iPod and iPad

This is how the alert looks like:  
  
![MLTableAlert](http://www.matthewlabs.com/resources/external/MLTableAlertGitHubSmall.png "MLTableAlert")  
  
Use MLTableAlert in your projects
---
1. Download the latest code version from the repository (using the Download Source button or your preferred command-line tool).
2. If you have to, extract the archive.
3. All you need is contained in the **MLTableAlert Files** folder.
4. Drag it to your project and make sure that the option Copy items is checked.
5. Add **QuartzCore framework** to your project.

Demo
---
A demo project, called **MLTableAlertDemo**, is included so you will see how to use this class.  

License
---
The license for this source code is included in the **Source Code License** file.  
It's a **BSD-like license with attribution**: you can use this code in your projects, even if they are commercial or closed-source; you only need to credit me!
For warranties and other info about this code, read the license file.  
  
Changelog
---
**Version 1.3 @ July 3rd, 2013**  
  
* Cancel button can also be omitted to show an alert for mandatory selection
* Cancel button drawing improvements
* Fixed typo and version numbers

**Version 1.2 @ March 30th, 2013**

* Landscape and Orientation support for iPad
* Bug fix  

**Version 1.1 @ December 31st, 2012**

* Custom height settings: now you can set your preferred height to the alert
* Changed properties to instance variables in initialization methods  

**Version 1.0 @ December 22nd, 2012**  

* Initial release: probably there are some bugs and the code could be improved…  
I'm here to hear your requests or issues and I hope this code will simplify your developer life!  
  
Credits
---  
**Matteo Del Vecchio**  
**Matthew Labs**  
  
Web: [Matthew Labs][2]  
Twitter: [@MatthewLabs][3]  
Facebook: [facebook.com/MatthewLabsDev][4]  
Google+: [Matthew Labs Page][5]  
  
  [1]: http://www.matthewlabs.com/blog/mltablealert-an-overview/
  [2]: http://www.matthewlabs.com/ "Matthew Labs"
  [3]: http://twitter.com/MatthewLabs "Matthew Labs on Twitter"
  [4]: http://www.facebook.com/MatthewLabsDev "Matthew Labs on Facebook"
  [5]: https://plus.google.com/117759042318503506347 "Matthew Labs on Google+"