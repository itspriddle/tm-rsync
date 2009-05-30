# TextMate rsync Bundle

Use this bundle to rsync your project directory with a remote host.  Invoke via ctrl+cmd+r

# Installation

git clone git://github.com/jpriddle/tm-rsync.git ~/Library/Application\ Support/TextMate/Bundles/rsync.tmbundle

osascript -e 'tell app "TextMate" to reload bundles'

# Setup

Add the following variables to your TM project (you can set them globally if you want)

  $SSH_KEY    
    The FULL system path to your public SSH key
    IE: /Users/priddle/.ssh/id_rsa.pub

  $SSH_HOST
    The IP/hostname of the server you are rsync'ing to

  $SSH_USER
    The username on the remove server

  $SSH_REMOTE_PATH
    The FULL system path to the remote directory to rsync to

  $RSYNC_OPTIONS
    Any extra options to pass to rsync, such as --dry-run or --delete

  $RSYNC_EXCLUDE_FROM
    The FULL system path to an rsync exclude file if you wish to use one
    OR a path relative to your TM_PROJECT_DIRECTORY

# Testing

Add '--dry-run' to $RSYNC_OPTIONS to run in testing mode
