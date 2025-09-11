#!/bin/bash

awk '{if ($12 <= 2.0) print $6}' rmsd.all.txt > cluster01.lst
awk '{if ($12 > 2.0) print $6}' rmsd.all.txt > cluster02.etc.lst
