# japanese-music-converter

A small script I'm making for my specific needs. It basically allows to convert musics from a folder recursively (that can accept any type of filename, like with spaces and such) to the ogg format, encoded in OPUS constant bitrate 96kbps, and to send them into a new folder that has the exact same structure as the original. It can also fix broken names caused by Windows with Japanese characters and its bad encoding (JSIS) by extracting the title of the musics from their metadata and renaming the files accordingly, while making sure there are no bad characters such as ":" or "/" in their name so neither Windows or Linux / MacOS complains about the filenames.

I'll add more features like title translations using web services such as Google Translate, and if possible, fetch  album covers from the web.

For this script to work, you will need to have FFMPEG and EXIFTOOL installed on your machine.

For Ubuntu :
sudo apt install ffmpeg exiftool

For Arch Linux :
sudo pacman -S ffmpeg exiftool

I felt like I could upload the script here so anybody in a situation similar to mine could solve problems tied to huge music filesizes (for smaller storage devices such as micro sd) and bad filenames because of the wrong character encoding used by some softwares.

I am aware that my script can be dirty, I just started learning how to use Bash, but it works so far. If you have any suggestion or correction to make, don't hesitate to contact me or make push requests, I'd be more than happy to see contributors for this small project.
I'm also learning how to use Github so I'll try to update this repository as I learn to use it.