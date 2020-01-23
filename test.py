"""
Tests for the XSLT conversion. Checks for compliance of each of the cases 
in the tests folder
"""
import unittest
from rdflib import Graph, BNode, URIRef
import lxml.etree as ET
import io
import re

def convert_tei_to_ontolex(tei_file_name, xsl_filename="Stylesheet/TEI2Ontolex.xsl"):
    dom = ET.parse(tei_file_name)
    xslt = ET.parse(xsl_filename)
    transform = ET.XSLT(xslt)
    newdom = transform(dom)
    g = Graph()
    with io.BytesIO(ET.tostring(newdom)) as out:
        g.parse(out)
    return g

def report(missing, overgen):
    s = ""
    if len(missing) > 0:
        s += "\nMissing:\n"
        s += "\n".join(str(m) for m in missing)
        s += "\n"
    if len(overgen) > 0:
        s += "Incorrect:\n"
        s += "\n".join(str(m) for m in overgen)
    return s

def test_graph(g):
    res = set()
    for s,p,o in g:
        if isinstance(s, BNode):
            s = "[]"
        elif isinstance(s, URIRef):
            s = re.sub("file:.*#", "#", s.n3())
        else:
            s = s.n3()
        p = p.n3()
        if isinstance(o, BNode):
            o = "[]"
        elif isinstance(o, URIRef):
            o = re.sub("file:.*#", "#", o.n3())
        else:
            o = o.n3()
        res.add((s,p,o))
    return res

def compare_rdf_graphs(expected_graph, actual_graph, test_case):
    g1 = test_graph(expected_graph)
    g2 = test_graph(actual_graph)
    missing = g1 - g2
    overgen = g2 - g1

    test_case.assertTrue(len(missing) + len(overgen) == 0,
            report(missing, overgen))

class TestTEI2OntoLex(unittest.TestCase):

    def test1(self):
        expected = Graph()
        with open("tests/test1.ttl") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test1.xml")
        compare_rdf_graphs(expected, actual, self)

    def test2(self):
        expected = Graph()
        with open("tests/test2.ttl") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test2.xml")
        compare_rdf_graphs(expected, actual, self)

    def test3(self):
        expected = Graph()
        with open("tests/test3.ttl", encoding="utf-8") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test3.xml")
        compare_rdf_graphs(expected, actual, self)


    def test4(self):
        expected = Graph()
        with open("tests/test4.ttl") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test4.xml")
        compare_rdf_graphs(expected, actual, self)


    def test5(self):
        expected = Graph()
        with open("tests/test5.ttl", encoding="utf-8") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test5.xml")
        compare_rdf_graphs(expected, actual, self)


    def test6(self):
        expected = Graph()
        with open("tests/test6.ttl") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test6.xml")
        compare_rdf_graphs(expected, actual, self)


    def test7(self):
        expected = Graph()
        with open("tests/test7.ttl") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test7.xml")
        compare_rdf_graphs(expected, actual, self)


    def test8(self):
        expected = Graph()
        with open("tests/test8.ttl") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test8.xml")
        compare_rdf_graphs(expected, actual, self)


    def test9(self):
        expected = Graph()
        with open("tests/test9.ttl") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test9.xml")
        compare_rdf_graphs(expected, actual, self)

    def test10(self):
        expected = Graph()
        with open("tests/test10.ttl") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test10.xml")
        compare_rdf_graphs(expected, actual, self)


if __name__ == "__main__":
    unittest.main()
