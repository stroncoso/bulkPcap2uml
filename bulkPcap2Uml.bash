#!/bin/bash

function show_help {
  echo ""
  echo "Bulk conversion Pcap2Uml"
  echo "  -h|?        : show this help"
  echo "  -s <DIR>    : set SOURCE folder (pcap)"
  echo "  -d <DIR>    : set DESTINATION folder (output)"
  echo "  -f          : force (no confirmation question)"
  echo "  -F <FILTER> : wiresahrk filter to use (default = 'sip||sccp||diameter||http')"
  echo "  -t <FORMAT> : output format (png,svg,eps,pdf, default=uml)"
  echo ""
  exit
}

# Initialize our own variables:
# DEST=""
# SRC=""
# FILTER="http|sip"

while getopts "h?s:d:fF:t:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    s)  SRC=${OPTARG%/}
        ;;
    d)  DEST=${OPTARG%/}
        ;;
    f)  FORCE=1
        ;;
    F)  FILTER="$OPTARG"
        ;;
    t)  OUTPUT="$OPTARG"
        ;;
    *)
        echo "Unknow argument ($opt)"
        show_help
        exit 1
    esac
done

if [ -z "$DEST" ]; then
  echo "Destination not set"
  show_help
  exit 1
elif [ -z "$SRC" ]; then
  echo "Source not set"
  show_help
  exit 1
fi

# Greeting
echo
echo "Bulk conversion Pcap2Uml"
echo "---------------"
echo "Source folder: $SRC"
echo "Destination folder: $DEST"
echo "Filter selected: $FILTER"
echo "Output format: $OUTPUT"
echo

if [ -z "$FORCE" ]; then
  while true; do
      echo "Do you wish to proceed?"
      read -p "(y/n) " yn
      case $yn in
          [Yy]* ) echo "Let's go!"; break;;
          [Nn]* ) exit 2;;
          * ) echo "Please answer yes or no.";;
      esac
  done
fi

if [ ! -d "$SRC" ]; then
  echo "Source folder does n$OUTPUTot exists"
  exit 3
elif  [ ! -d "$DEST" ]; then
  echo "Destination folder does not exists"
  exit 3
fi

#Prepare filter string
if [ ! -z "$FILTER" ]; then
  FILTER="-y $FILTER"
fi

#Prepare output parameter string
if [ ! -z "$OUTPUT" ]; then
  OUTPUT="-t $OUTPUT"
fi

echo "Bulk conversion started, please wait..."

#Prepare a log file
TIMESTAMP=$(date)
LOGFILE="bulklog-$(date +"%Y%m%d").txt"
cat >> "$LOGFILE" << EOM
---------------
Bulk conversion Pcap2Uml
---------------
Start time: $(date)
Source folder: $SRC
Destination folder: $DEST
Filter selected: ${FILTER#"-y "}
Output format: ${OUTPUT#"-t "}
EOM

## pcap2uml system call
# Arg1: source file

function process_file () {
  #statements
  echo ">>> processing $1"
  filename=$(basename -- "$1")
  extension="${filename##*.}"
  filename="${filename%.*}"
  echo " file: $filename"
  echo " ext: $extension"

  if [ "$extension" != "pcap" ] && [ "$extension" != "pcapng" ] ; then
    echo "WARNING: maybe not a pcap file ($1) Skipping"
    return
  fi

  echo " command: pcap2uml.py $FILTER $OUTPUT -i $1 -o \"$DEST/${filename}.uml"
  ./pcap2uml.py $FILTER $OUTPUT -i $1 -o "$DEST/${filename}.uml"
  if [ -z $? ] ; then
    echo "ERROR: Unable to convert file ($1)"
  fi
  echo "conversion done"
  echo "<<<"

}

# Bulk process
for f in $SRC/*; do
    process_file $f >> "$LOGFILE"
    echo -n "."
done

echo " DONE!"

cat >> "$LOGFILE" << EOM
---------------
Conversion ends
---------------
EOM
