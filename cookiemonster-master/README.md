# cookiemonster
_Shared cookies using an invisible SFSafariViewController._

### Why?
This is meant as a simulation for sharing arbitrary data through an App Store download.

### To use:
  * Start the web server by running `testcookie.sh`.
  * Build and run `CookieMonster.app` in `Xcode` for Simulator or device. 
  * Tapping on `Create Code` will open mobile Safari to [index.html](https://github.com/meekapps/cookiemonster/blob/master/index.html). Alternatively navigate to `http://<hostname>:8000/index.html` (where `<hostname>` is `localhost` on the Simulator, or your IP address on a device). 
  * Enter an arbitrary code to share with `CookieMonster.app`
  * Go back to `CookieMonster.app` and tap `Eat Cookie`. Whatever you entered in Safari should show in an alert view.
 

### How it works:
  * `testcookie.sh` really just runs `SimpleHTTPServer` (alternatively `python -m SimpleHTTPServer`)
  * The [index.html](https://github.com/meekapps/cookiemonster/blob/master/index.html) page saves the entered code as a cookie.         
  * When tapping on `Eat Cookie` in the app, an invisible [SFSafariViewController](https://developer.apple.com/library/ios/documentation/SafariServices/Reference/SFSafariViewController_Ref/) is presented without animation. 
  * The Safari view loads the page [monster.html](https://github.com/meekapps/cookiemonster/blob/master/monster.html), which consumes the previously saved cookie and delivers it back to the app via a custom URL scheme query parameter. 
  *  The app parses the custom URL scheme query to consume the code (i.e. `cookiemonster://opencode?code=<code>`).
  
### Demo:
[demo.mov](https://github.com/meekapps/cookiemonster/blob/master/demo.mov)
  

