# names in error messages are indexed correctly

    Code
      coalesce(1, "x")
    Error <vctrs_error_incompatible_type>
      Can't combine `..1` <double> and `..2` <character>.

---

    Code
      coalesce(1, y = "x")
    Error <vctrs_error_incompatible_type>
      Can't combine `..1` <double> and `y` <character>.

# `...` can't be empty

    Code
      coalesce()
    Error <rlang_error>
      `...` can't be empty.

---

    Code
      coalesce(NULL)
    Error <rlang_error>
      `...` can't be empty.

# `.size` can override the common size

    Code
      coalesce(1L, 2:4, .size = 2L)
    Error <vctrs_error_incompatible_size>
      Can't recycle `..2` (size 3) to size 2.

---

    Code
      coalesce(1L, x = 2:4, .size = 2L)
    Error <vctrs_error_incompatible_size>
      Can't recycle `x` (size 3) to size 2.

