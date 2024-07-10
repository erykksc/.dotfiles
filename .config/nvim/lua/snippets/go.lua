return {
	s("iferr", {
		t({ "if err != nil {", "\t" }),
		i(0, "return err"),
		t({ "", "}" }),
	}),
}
