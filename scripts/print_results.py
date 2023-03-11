#!/usr/bin/env python3

import argparse
import json

def main(args):
    print(args.submissionid)
    with open(args.file, 'r') as f:
        results = json.load(f)
        for v in result:
            print(v)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--submissionid", required=True,
                        help="Submission Id")
    parser.add_argument("-f", "--file", required=True,
                        help="Results file")
    args = parser.parse_args()
    main(args)