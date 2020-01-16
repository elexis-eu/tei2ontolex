"""
Tests for the XSLT conversion. Checks for compliance of each of the cases 
in the tests folder
"""
import unittest
from rdflib import Graph, BNode
import lxml.etree as ET
import io

def convert_tei_to_ontolex(tei_file_name, xsl_filename="Stylesheet/TEI2Ontolex.xsl"):
    dom = ET.parse(tei_file_name)
    xslt = ET.parse(xsl_filename)
    transform = ET.XSLT(xslt)
    newdom = transform(dom)
    g = Graph()
    with io.BytesIO(ET.tostring(newdom)) as out:
        g.parse(out)
    return g

def compare_rdf_graphs(expected_graph, actual_graph, test_case):
    for s,p,o in expected_graph:
        if isinstance(s, BNode):
            s2 = None
        else:
            s2 = s
        if isinstance(o, BNode):
            o2 = None
        else:
            o2 = o
        test_case.assertTrue((s2,p,o2) in actual_graph,
                "A triple was missing: %s %s %s" % (s.n3(), p.n3(), o.n3()))

    for s,p,o in actual_graph:
        if isinstance(s, BNode):
            s2 = None
        else:
            s2 = s
        if isinstance(o, BNode):
            o2 = None
        else:
            o2 = o
        test_case.assertTrue((s2,p,o2) in expected_graph,
                "A generated triple was not expected: %s %s %s" % (s.n3(), p.n3(), o.n3()))

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
        with open("tests/test3.ttl") as ttl:
            expected.parse(ttl, format="turtle")
        actual = convert_tei_to_ontolex("tests/test3.xml")
        compare_rdf_graphs(expected, actual, self)

if __name__ == "__main__":
    unittest.main()
