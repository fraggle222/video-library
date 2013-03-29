This simple project will pull YouTube playlists and display the videos in a "Pulse" styled grid (horizontal
and vertical scrolling).

You can edit the Config.plist file to specify the baseURL. This should be of the form:
https://gdata.youtube.com/feeds/api/users/YouTubeUserName/playlists?v=2

You can also specify a title for the main screen there. Future updates will include more configuration entries for
colors, sizes, etc.

In the current release, the playlists need to be public, however, since this project includes the GData classes
from Google it would be fairly easy to authenticate for private access.

The grid will scroll horizontally and vertically. When a cell is touched it launches another view controller which holds 
a webview to run the youtube video.

Notes: iPad version is on its way (project is a universal app but iPad screens are not completed yet).
