# level inputs are cast to character

    Code
      fct_when(TRUE, 1)
    Error <vctrs_error_incompatible_type>
      Can't convert `..2` <double> to <character>.

# `.default` is cast to character

    Code
      fct_when(TRUE, "x", .default = 1)
    Error <vctrs_error_incompatible_type>
      Can't convert `.default` <double> to <character>.

# `.missing` is cast to character

    Code
      fct_when(TRUE, "x", .missing = 1)
    Error <vctrs_error_incompatible_type>
      Can't convert `.missing` <double> to <character>.

# levels can't be duplicated

    Code
      fct_when(c(TRUE, FALSE), "x", c(FALSE, TRUE), "x")
    Error <rlang_error>
      Factor levels can't be duplicated.
      i Level "x" is duplicated.

---

    Code
      fct_when(c(TRUE, FALSE), "x", .default = "x")
    Error <rlang_error>
      Factor levels can't be duplicated.
      i Level "x" is duplicated.

---

    Code
      fct_when(c(TRUE, FALSE), "x", .missing = "x")
    Error <rlang_error>
      Factor levels can't be duplicated.
      i Level "x" is duplicated.

# level inputs must be single strings

    Code
      fct_when(c(TRUE, FALSE), "x", c(FALSE, TRUE), c("a", "b"))
    Error <rlang_error>
      All value inputs must be strings.
      i `..4` is length 2.

---

    Code
      fct_when(c(TRUE, FALSE), "x", c(FALSE, TRUE), bar = c("a", "b", "c"))
    Error <rlang_error>
      All value inputs must be strings.
      i `bar` is length 3.

# must contain at least one input

    Code
      fct_when()
    Error <rlang_error>
      `...` can't be empty.

# must contain an even number of inputs

    Code
      fct_when(TRUE)
    Error <rlang_error>
      `...` must contain an even number of inputs.
      i 1 inputs were provided.

# `.default` must be a single string

    Code
      fct_when(c(TRUE, FALSE), "x", .default = c("a", "b"))
    Error <rlang_error>
      `.default` must be a string.
      i `.default` is length 2.

# `.missing` must be a single string

    Code
      fct_when(c(TRUE, FALSE), "x", .missing = c("a", "b"))
    Error <rlang_error>
      `.missing` must be a string.
      i `.missing` is length 2.

# `.size` can enforce a size for the logical conditions

    Code
      fct_when(TRUE, "x", .size = 2)
    Error <vctrs_error_assert_size>
      `..1` must have size 2, not size 1.

# `.ordered` is validated

    Code
      fct_when(TRUE, "x", .ordered = 1)
    Error <rlang_error>
      `.ordered` must be a single `TRUE` or `FALSE`.

