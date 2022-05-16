# is size stable on the size of `condition`

    Code
      if_else(TRUE, 1:2, 1L)
    Error <vctrs_error_assert_size>
      `true` must have size 1, not size 2.

# `condition` must be castable to logical

    Code
      if_else("x", 1, 2)
    Error <vctrs_error_incompatible_type>
      Can't convert `condition` <character> to <logical>.

# common type errors mention arg names

    Code
      if_else(TRUE, "x", 3)
    Error <vctrs_error_incompatible_type>
      Can't combine `true` <character> and `false` <double>.

---

    Code
      if_else(TRUE, "x", "y", missing = 3)
    Error <vctrs_error_incompatible_type>
      Can't combine `true` <character> and `missing` <double>.

# common size errors mention arg names

    Code
      if_else(c(TRUE, FALSE), 1:3, 1)
    Error <vctrs_error_assert_size>
      `true` must have size 2, not size 3.

---

    Code
      if_else(c(TRUE, FALSE), 1, 1:3)
    Error <vctrs_error_assert_size>
      `false` must have size 2, not size 3.

# must have empty dots

    Code
      if_else(TRUE, 1, 2, 3)
    Error <rlib_error_dots_nonempty>
      `...` must be empty.
      x Problematic argument:
      * ..1 = 3
      i Did you forget to name an argument?

