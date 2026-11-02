"""Validate project JSON-LD after building the Jekyll site."""

import json
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]


def schemas():
    html = (ROOT / "_site/index.html").read_text(encoding="utf-8")
    return [json.loads(raw) for raw in re.findall(
        r'<script[^>]*type="application/ld\+json"[^>]*>(.*?)</script>', html, re.S)]


class StructuredDataTests(unittest.TestCase):
    def test_software_is_archived_r_code_with_its_own_identity(self):
        blocks = schemas()
        code, = [item for item in blocks if item.get("@type") == "SoftwareSourceCode"]
        self.assertEqual(code["programmingLanguage"], "R")
        self.assertEqual(code["license"], "https://opensource.org/licenses/MIT")
        self.assertEqual(code["codeRepository"], "https://github.com/dieghernan/" + ROOT.name)
        self.assertEqual(code["@id"], "https://dieghernan.github.io/" + ROOT.name + "/#source-code")
        self.assertEqual(code["author"]["url"], "https://dieghernan.github.io/")
        self.assertEqual(code["author"]["sameAs"], "https://orcid.org/0000-0001-8457-4658")
        self.assertEqual([item for item in blocks if item.get("@type") == "WebApplication"], [])
        self.assertNotIn("version", code)

    def test_dataset_matches_the_archived_csv(self):
        import csv
        from urllib.parse import unquote, urlparse

        blocks = schemas()
        dataset, = [item for item in blocks if item.get("@type") == "Dataset"]
        code, = [item for item in blocks if item.get("@type") == "SoftwareSourceCode"]
        with (ROOT / "assets/data/COVIDEsp_actual.csv").open(encoding="utf-8", newline="") as stream:
            rows = list(csv.DictReader(stream))
        dates = sorted(row["Fecha"] for row in rows)
        self.assertEqual(dataset["temporalCoverage"], f"{dates[0]}/{dates[-1]}")
        self.assertIn(str(len(rows)), dataset["description"])
        self.assertIn("obsoleto", dataset["description"])
        self.assertGreaterEqual(len(dataset["description"]), 50)
        self.assertLessEqual(len(dataset["description"]), 5000)
        self.assertEqual(dataset["dateCreated"], rows[0]["tmstamp"].replace(" ", "T", 1).replace(" UTC", "Z"))
        self.assertEqual(code["about"]["@id"], dataset["@id"])
        self.assertEqual(dataset["isBasedOn"]["publisher"]["alternateName"], "ISCIII")
        self.assertNotIn("license", dataset)
        for variable in dataset["variableMeasured"]:
            self.assertIn(variable.replace("Casos activos", "Casos_Activos"), rows[0])
        download, = dataset["distribution"]
        self.assertEqual(download["encodingFormat"], "text/csv")
        path = unquote(urlparse(download["contentUrl"]).path).removeprefix("/COVID19/")
        self.assertEqual(path, "assets/data/COVIDEsp_actual.csv")
        self.assertTrue((ROOT / path).is_file())


if __name__ == "__main__":
    unittest.main()
