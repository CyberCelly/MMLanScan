#!/usr/bin/python
import urllib2
import xml.etree.ElementTree as ElementTree
import re


def refine_table(table):
    result = table
    result = re.sub(r"<td.*?>", "<td>", result)
    result = re.sub(r"<tr.*?>", "<tr>", result)
    result = re.sub(r"<a.*?>(.*?)</a>", "\\1", result)
    result = re.sub(r"<span.*?>(.*?)</span>", "\\1", result)
    result = re.sub(r"<b.*?>(.*?)</b>", "\\1", result)
    result = re.sub(r"<br\s?/>", "", result)
    result = re.sub(r"<sup.*?/sup>", "", result)
    result = re.sub(r"<sub.*?/sub>", "", result)
    result = re.sub(r"<caption.*?/caption>", "", result)
    result = re.sub(r"</abbr>", "", result)
    result = re.sub(r"\n", "", result)
    result = re.sub(r"<div.*?>.*?<li>(.*?)</li>.*?</div>", "\\1", result, re.M | re.S)

    return result


def main():
    response = urllib2.urlopen("https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers")
    content = response.read()

    tables = re.findall(r"<table class=\"wikitable sortable collapsible\">(.*?)</table>", content, re.M | re.S)
    table_well_known = refine_table(tables[0])
    table_registered_known = refine_table(tables[1])
    whole_table = "<table>" + table_well_known + table_registered_known + "</table>"

    tree = ElementTree.fromstring(whole_table)

    port_info = {}

    for child in tree:
        port = child[0].text
        tcp = child[1].text
        udp = child[2].text
        desc = (child[3][0].text if len(child[3]) > 0 else child[3].text).replace(",", "").replace(".", "")

        # skip invalid entries
        if not port:
            continue

        if ("Reserved" in [tcp, udp]) or ("N/A" in [tcp, udp]):
            continue

        # defaulting to TCP
        if (not tcp and not udp):
            tcp = "TCP"
        elif tcp and tcp.lower() in ["yes", "assigned", "?"]:
            tcp = "TCP"

        if udp and udp.lower() in ["yes", "assigned", "?"]:
            tcp = "TCP"

        # check if given is port range
        try:
            port_range = map(int, port.split("-"))
        except:
            continue

        port_range = [int(port)] if port.isdigit() else map(int, port.split("-"))
        for p in port_range:
            if p not in port_info:
                port_info[p] = [set(),[]]

            if tcp == "TCP":
                port_info[p][0].add("tcp")

            if udp == "UDP":
                port_info[p][0].add("udp")

            port_info[p][1].append(desc)

    with open("services.list", "w") as fsvcs:
        for port, info in sorted(port_info.items()):
            for proto in sorted(info[0]):
                svc = (" | ".join(info[1])).replace(u"\u00e9", "e").replace(u"\u2013", "-").replace(u"\u2014", "-")
                fsvcs.write(("%s,%s,%s" % (proto, port, svc)))
                fsvcs.write("\n")


if __name__ == "__main__":
    main()

