package main

import (
	"bufio"
	"bytes"
	"fmt"
	"maps"
	"os"
	"slices"
	"strings"
)

const brewfile = "Brewfile"

func fail(format string, a ...any) {
	fmt.Fprintf(os.Stderr, "sort_brewfile: "+format+"\n", a...)
	os.Exit(1)
}

func isFormula(s string) bool {
	return strings.HasPrefix(s, "brew ") || strings.HasPrefix(s, "cask ") || strings.HasPrefix(s, "mas ")
}

func main() {
	f, err := os.Open(brewfile)
	if err != nil {
		fail("could not open %s: %s", brewfile, err)
	}
	defer f.Close()
	var (
		scanner      = bufio.NewScanner(f)
		formulas     = make(map[string]string)
		formulaStart = -1
		lines        []string
	)
	for scanner.Scan() {
		line := scanner.Text()
		lines = append(lines, line)
		i := len(lines) - 1
		if line == "" && i > 0 && strings.HasPrefix(lines[i-1], "tap ") {
			formulaStart = len(lines)
		}
		if !isFormula(line) {
			continue
		}
		formulas[line] = lines[i-1]
	}
	if err := scanner.Err(); err != nil {
		fail("failed scanning file: %s", err)
	}
	if formulaStart < 0 {
		fail("could not find any formulas in %s", brewfile)
	}
	var buf bytes.Buffer
	for _, line := range lines[:formulaStart] {
		buf.WriteString(line)
		buf.WriteString("\n")
	}
	for _, formula := range slices.Sorted(maps.Keys(formulas)) {
		comment := formulas[formula]
		if strings.HasPrefix(comment, "#") {
			buf.WriteString(comment)
			buf.WriteString("\n")
		}
		buf.WriteString(formula)
		buf.WriteString("\n")
	}
	if err := os.WriteFile(brewfile, buf.Bytes(), 0644); err != nil {
		fail("failed to write %s: %s", brewfile, err)
	}
}
