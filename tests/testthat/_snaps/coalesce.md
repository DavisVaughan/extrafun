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

