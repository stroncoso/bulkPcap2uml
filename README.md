# BulkPcap2uml

Bulk converter for **pcap2uml** Python script.

**More about pcap2uml**

IMS Call flow visualizer for HTTP, SIP, Diameter, GSM MAP and CAMEL protocols

This program can parse inpur pcap and generate result in plantuml, png, pdf or svg formats.

Project page: https://github.com/dgudtsov/pcap2uml

Uses pyshark library: http://kiminewt.github.io/pyshark/
and plantuml sequence diagram: http://plantuml.com/ along with some other basic system dependencies.

## 1. Prerequisites

* Python 2 version >= 2.6

  *NOTE: Python 3 is not supported*

* pyshark-legacy library https://github.com/KimiNewt/pyshark

  `$ pip install pyshark-legacy`

  *NOTE: python 2 requires pyshark-legacy instead pyshark*

* Java runtime

  `$ sudo apt install default-jre`

* Plantuml: http://plantuml.com/download

## 2. Advanced configuration

The repository includes a default functional configuration file, but you can configure advanced options following the next instructions:

Edit `conf/conf_uml.py` file:
1. define 'participants' dict
2. define 'uml_intro'
3. define plantuml library and java path in JAVA_BIN and plantuml_jar params


## 3. Usage

run:
```
./bulkPcap2Uml.bash -s <SOURCE> -d <OUT_DIR> -t png

```

where:
```
  -h|?        : show this help
  -s <DIR>    : set SOURCE folder (pcap)"
  -d <DIR>    : set DESTINATION folder (output)"
  -f          : [OPTIONAL] force, do not prompt prior to start (default = false)"
  -F <FILTER> : [OPTIONAL] wireshark filter to use (default = 'sip||sccp||diameter||http')"
  -t <FORMAT> : [OPTIONAL] output format: png,svg,eps,pdf (default=uml)"
```

This will produce in `<OUT_DIR>` a full set of output files based on the `-t` parser defined in adition with the UML files generated. If not defined, only the UML files will be produced.

The file names will be based directly on the names of `pcap` files from `<SOURCE>` folder. The bulk script will skip any file that was detected as non-pcap file.

For extra info, a log file will be produced on the running folder.

### 3.1 `pcap2uml` direct usage
```
./pcap2uml.py -i input.pcap -o out.uml -y filter -t format
```

where:
* input.pcap - source pcap (mandatory)
* out.uml - result diagram in PlanUML format (optional, default is ./out.uml)
* filter - wireshark view filter (optional, default = 'sip||sccp||diameter||http')
* format - png,svg,eps,pdf (optional)

As a result, plantuml diagram will be generated.
If you have defined -t option, then appropriate document will be generated as well along with uml source

Then, to generate graphical version of diagram, run (if you didn't define -t option):
java -jar plantuml.jar -tpng out.uml

The plantuml will generate out.png in result.

### 3.2 `pcap2uml` usage notice

If you didn't define all parties in `'participants'` dict in `conf/conf_uml.py` file, then program will dump list of undefined participants for you. You can copy that list and paste it into configuration file and then fill it values with appropriate names.

Please note about filter syntax. It should be escaped and do not contains whitespaces, e.g.:
```
sip.Call-ID==\"0feX8451416300Q3beGhEfIgAke@SIP\"\\|\\|sip.Call-ID==\"0050569E78EF-554c-acc81700-becf6-588f3c46-495a\"
```
## 4. Advanced usage

You can edit `'proto_formatter'` dict in `conf/conf_uml.py` and define there any field from protocol that you want. Before adding new header line, please ensure the same line defined in `'headers'` dict. Because only headers defined in `'headers'` dict are considered.
