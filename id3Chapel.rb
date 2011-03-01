#!/usr/bin/ruby -w
# INCOMPLETE - I never finished this because the id3Chapel.sh as "good enough"

# Converting this bash script to a ruby script
ls -1 *.mp3 | awk -F . '{ system ("id3v2 -A \"WBC Chapels "$3"\" -a \""$4" "$5"\" -c \""$6" "$7" by "$4" "$5" on "$1"/"$2"/"$3" in "$8" format\" -t \""$6" "$7"\" -g 28 -y "$3" "$0)}'

#if the file is an MP3 enter into an array to work on later
#
#Get Extension
#File.extname("~/file.mp3") -> ".mp3"
#

#id3lib Example
# require 'rubygems'
# require 'id3lib'

# Load a tag from a file
# tag = ID3Lib::Tag.new('talk.mp3')
#
# # Get and set text frames with convenience methods
# tag.title  #=> "Talk"
# tag.album = 'X&Y'
# tag.track = '5/13'
#
# # Tag is a subclass of Array and each frame is a Hash
# tag[0]
# #=> { :id => :TPE1, :textenc => 0, :text => "Coldplay" }
#
# # Get the number of frames
# tag.length  #=> 7
#
# # Remove all comment frames
# tag.delete_if{ |frame| frame[:id] == :COMM }
#
# # Get info about APIC frame to see which fields are allowed
# ID3Lib::Info.frame(:APIC)
# #=> [ 2, :APIC, "Attached picture",
# #=>   [:textenc, :mimetype, :picturetype, :description, :data] ]
#
# # Add an attached picture frame
# cover = {
#   :id          => :APIC,
#   :mimetype    => 'image/jpeg',
#   :picturetype => 3,
#   :description => 'A pretty picture',
#   :textenc     => 0,
#   :data        => File.read('cover.jpg')
# }
# tag << cover
#
# # Last but not least, apply changes
# tag.update!

