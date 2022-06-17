# `conditions` inputs can be size zero

    Code
      vec_case_when(list(logical()), list(1:2))
    Error <vctrs_error_assert_size>
      `..1` must have size 0, not size 2.

# `values` are cast to their common type

    Code
      vec_case_when(list(FALSE, TRUE), list(1, "x"))
    Error <vctrs_error_incompatible_type>
      Can't combine `..1` <double> and `..2` <character>.

# `values` must be size 1 or same size as the `conditions`

    Code
      vec_case_when(list(c(TRUE, FALSE, TRUE, TRUE)), list(1:3))
    Error <vctrs_error_assert_size>
      `..1` must have size 4, not size 3.

# `default` must be size 1 or same size as `conditions` (exact same as any other `values` input)

    Code
      vec_case_when(list(FALSE), list(1L), default = 2:3)
    Error <vctrs_error_assert_size>
      `default` must have size 1, not size 2.

# `default_arg` can be customized

    Code
      vec_case_when(list(FALSE), list(1L), default = 2:3, default_arg = "foo")
    Error <vctrs_error_assert_size>
      `foo` must have size 1, not size 2.

---

    Code
      vec_case_when(list(FALSE), list(1L), default = "x", default_arg = "foo")
    Error <vctrs_error_incompatible_type>
      Can't combine `..1` <integer> and `foo` <character>.

# `conditions_arg` is validated

    Code
      vec_case_when(list(TRUE), list(1), conditions_arg = 1)
    Error <rlang_error>
      `conditions_arg` must be a string.

# `values_arg` is validated

    Code
      vec_case_when(list(TRUE), list(1), values_arg = 1)
    Error <rlang_error>
      `values_arg` must be a string.

# `default_arg` is validated

    Code
      vec_case_when(list(TRUE), list(1), default_arg = 1)
    Error <rlang_error>
      `default_arg` must be a string.

# `conditions` must all be the same size

    Code
      vec_case_when(list(c(TRUE, FALSE), TRUE), list(1, 2))
    Error <vctrs_error_assert_size>
      `..2` must have size 2, not size 1.

---

    Code
      vec_case_when(list(c(TRUE, FALSE), c(TRUE, FALSE, TRUE)), list(1, 2))
    Error <vctrs_error_incompatible_size>
      Can't recycle `..1` (size 2) to match `..2` (size 3).

# `conditions` must be logical (and aren't cast to logical!)

    Code
      vec_case_when(list(1), list(2))
    Error <vctrs_error_assert_ptype>
      `..1` must be a vector with type <logical>.
      Instead, it has type <double>.

---

    Code
      vec_case_when(list(TRUE, 3.5), list(2, 4))
    Error <vctrs_error_assert_ptype>
      `..2` must be a vector with type <logical>.
      Instead, it has type <double>.

# `size` overrides the `conditions` sizes

    Code
      vec_case_when(list(TRUE), list(1), size = 5)
    Error <vctrs_error_assert_size>
      `..1` must have size 5, not size 1.

---

    Code
      vec_case_when(list(c(TRUE, FALSE), c(TRUE, FALSE, TRUE)), list(1, 2), size = 2)
    Error <vctrs_error_assert_size>
      `..2` must have size 2, not size 3.

# `ptype` overrides the `values` types

    Code
      vec_case_when(list(FALSE, TRUE), list(1, 2), ptype = character())
    Error <vctrs_error_incompatible_type>
      Can't convert `..1` <double> to <character>.

# number of `conditions` and `values` must be the same

    Code
      vec_case_when(list(TRUE), list())
    Error <rlang_error>
      The number of supplied conditions (1) must equal the number of supplied values (0).

---

    Code
      vec_case_when(list(TRUE, TRUE), list(1))
    Error <rlang_error>
      The number of supplied conditions (2) must equal the number of supplied values (1).

# can't have empty inputs

    Code
      vec_case_when(list(), list())
    Error <rlang_error>
      At least one condition must be supplied.

---

    Code
      vec_case_when(list(), list(), default = 1)
    Error <rlang_error>
      At least one condition must be supplied.

# dots must be empty

    Code
      vec_case_when(list(TRUE), list(1), 2)
    Error <rlib_error_dots_nonempty>
      `...` must be empty.
      x Problematic argument:
      * ..1 = 2
      i Did you forget to name an argument?

# `conditions` must be a list

    Code
      vec_case_when(1, list(2))
    Error <rlang_error>
      `conditions` must be a list, not a number.

# `values` must be a list

    Code
      vec_case_when(list(TRUE), 1)
    Error <rlang_error>
      `values` must be a list, not a number.

# named inputs show up in the error message

    Code
      vec_case_when(list(x = 1.5), list(1))
    Error <vctrs_error_assert_ptype>
      `x` must be a vector with type <logical>.
      Instead, it has type <double>.

---

    Code
      vec_case_when(list(x = 1.5), list(1), conditions_arg = "foo")
    Error <vctrs_error_assert_ptype>
      `foo$x` must be a vector with type <logical>.
      Instead, it has type <double>.

---

    Code
      vec_case_when(list(x = TRUE, y = c(TRUE, FALSE)), list(1, 2))
    Error <vctrs_error_assert_size>
      `x` must have size 2, not size 1.

---

    Code
      vec_case_when(list(x = TRUE, y = c(TRUE, FALSE)), list(1, 2), conditions_arg = "foo")
    Error <vctrs_error_assert_size>
      `foo$x` must have size 2, not size 1.

---

    Code
      vec_case_when(list(TRUE, FALSE), list(1, x = "y"))
    Error <vctrs_error_incompatible_type>
      Can't combine `..1` <double> and `x` <character>.

---

    Code
      vec_case_when(list(TRUE, FALSE), list(1, x = "y"), values_arg = "foo")
    Error <vctrs_error_incompatible_type>
      Can't combine `foo[[1]]` <double> and `foo$x` <character>.

---

    Code
      vec_case_when(list(TRUE), list(NULL))
    Error <vctrs_error_scalar_type>
      `..1` must be a vector, not NULL.

---

    Code
      vec_case_when(list(TRUE), list(x = NULL))
    Error <vctrs_error_scalar_type>
      `x` must be a vector, not NULL.

---

    Code
      vec_case_when(list(TRUE), list(NULL), values_arg = "foo")
    Error <vctrs_error_scalar_type>
      `foo[[1]]` must be a vector, not NULL.

---

    Code
      vec_case_when(list(TRUE), list(x = NULL), values_arg = "foo")
    Error <vctrs_error_scalar_type>
      `foo$x` must be a vector, not NULL.

