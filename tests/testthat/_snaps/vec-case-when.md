# odd numbered inputs can be size zero

    Code
      vec_case_when(integer(), 1:2)
    Error <vctrs_error_assert_size>
      `..2` must have size 0, not size 2.

# even numbered inputs are cast to their common type

    Code
      vec_case_when(FALSE, 1, TRUE, "x")
    Error <vctrs_error_incompatible_type>
      Can't combine `..2` <double> and `..4` <character>.

# even numbered inputs must be size 1 or same size as logical conditions

    Code
      vec_case_when(c(TRUE, FALSE, TRUE, TRUE), 1:3)
    Error <vctrs_error_assert_size>
      `..2` must have size 4, not size 3.

# `.default` must be size 1 or same size as logical conditions (exact same as any other even numbered input)

    Code
      vec_case_when(FALSE, 1L, .default = 2:3)
    Error <vctrs_error_assert_size>
      `.default` must have size 1, not size 2.

# `.default_arg` can be customized

    Code
      vec_case_when(FALSE, 1L, .default = 2:3, .default_arg = "foo")
    Error <vctrs_error_assert_size>
      `foo` must have size 1, not size 2.

---

    Code
      vec_case_when(FALSE, 1L, .default = "x", .default_arg = "foo")
    Error <vctrs_error_incompatible_type>
      Can't combine `..2` <integer> and `foo` <character>.

# `.default_arg` is validated

    Code
      vec_case_when(TRUE, 1, .default_arg = 1)
    Error <rlang_error>
      `.default_arg` must be a string.

# odd numbered inputs must all be the same size

    Code
      vec_case_when(c(TRUE, FALSE), 1, TRUE, 2)
    Error <rlang_error>
      All odd numbered `...` inputs must be size 2.
      i `..3` is size 1.

---

    Code
      vec_case_when(c(TRUE, FALSE), 1, c(TRUE, FALSE, TRUE), 2)
    Error <vctrs_error_incompatible_size>
      Can't recycle `..1` (size 2) to match `..3` (size 3).

# odd numbered inputs must be logical

    Code
      vec_case_when(1.5, 2)
    Error <vctrs_error_cast_lossy>
      Can't convert `..1` <double> to <logical>.

---

    Code
      vec_case_when(1, 2, 3.5, 4)
    Error <vctrs_error_cast_lossy>
      Can't convert `..3` <double> to <logical>.

# `.size` overrides the odd numbered input sizes

    Code
      vec_case_when(TRUE, 1, .size = 5)
    Error <rlang_error>
      All odd numbered `...` inputs must be size 5.
      i `..1` is size 1.

---

    Code
      vec_case_when(c(TRUE, FALSE), 1, c(TRUE, FALSE, TRUE), 2, .size = 2)
    Error <rlang_error>
      All odd numbered `...` inputs must be size 2.
      i `..3` is size 3.

# `.ptype` overrides the even numbered input types

    Code
      vec_case_when(FALSE, 1, TRUE, 2, .ptype = character())
    Error <vctrs_error_incompatible_type>
      Can't convert `..2` <double> to <character>.

# can't have an odd number of inputs

    Code
      vec_case_when(1)
    Error <rlang_error>
      `...` must contain an even number of inputs.
      i 1 inputs were provided.

---

    Code
      vec_case_when(1, 2, 3)
    Error <rlang_error>
      `...` must contain an even number of inputs.
      i 3 inputs were provided.

# can't have empty dots

    Code
      vec_case_when()
    Error <rlang_error>
      `...` can't be empty.

---

    Code
      vec_case_when(.default = 1)
    Error <rlang_error>
      `...` can't be empty.

# named dots show up in the error message

    Code
      vec_case_when(x = 1.5, 1)
    Error <vctrs_error_cast_lossy>
      Can't convert `x` <double> to <logical>.

---

    Code
      vec_case_when(x = TRUE, 1, y = c(TRUE, FALSE), 2)
    Error <rlang_error>
      All odd numbered `...` inputs must be size 2.
      i `x` is size 1.

---

    Code
      vec_case_when(TRUE, 1, FALSE, x = "y")
    Error <vctrs_error_incompatible_type>
      Can't combine `..2` <double> and `x` <character>.

