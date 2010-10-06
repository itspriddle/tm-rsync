# TextMate rsync Bundle

Use this bundle to rsync your project directory with a remote host.  Invoke
via **&#8963;+&#8984;+r**


## Installation

    % git clone git://github.com/jpriddle/tm-rsync.git ~/Library/Application\ Support/TextMate/Bundles/rsync.tmbundle
    % osascript -e 'tell app "TextMate" to reload bundles'


## Setup

Add the following variables to your TM project (you can set them globally if
you want):

    $SSH_REMOTE_PATH (Required)
      The FULL system path to the remote directory to rsync to

    $SSH_HOST (Required)
      The IP/hostname of the server you are rsyncing to

    $SSH_KEY (Optional)
      The FULL system path to your public SSH key (eg:
      /Users/priddle/.ssh/id_rsa.pub.). If passed, rsync is run with
      `-i $SSH_KEY`

    $SSH_USER (Optional)
      The username on the remove server. If not specified, ssh uses the
      local system's current user.

    $RSYNC_OPTIONS (Optional)
      Any extra options to pass to rsync, such as --dry-run or --delete

    $RSYNC_EXCLUDE_FROM (Optional)
      The FULL system path to an rsync exclude file if you wish to use one
      OR a path relative to your TM_PROJECT_DIRECTORY


## Testing

Add `--dry-run` to $RSYNC_OPTIONS to run in testing mode
