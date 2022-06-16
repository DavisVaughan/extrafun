# `.missing` shows the right arg name

    Code
      case_when(TRUE, 1, .missing = "x")
    Error <vctrs_error_incompatible_type>
      Can't combine `..2` <double> and `.missing` <character>.

# `.default` shows the right arg name

    Code
      case_when(TRUE, 1, .default = "x")
    Error <vctrs_error_incompatible_type>
      Can't combine `..2` <double> and `.default` <character>.

# input names are used in error messages

    Code
      case_when(TRUE, 1, x = 1, 2)
    Error <vctrs_error_assert_ptype>
      `x` must be a vector with type <logical>.
      Instead, it has type <double>.

---

    Code
      case_when(TRUE, 1, TRUE, x = "x")
    Error <vctrs_error_incompatible_type>
      Can't combine `..2` <double> and `x` <character>.

# inputs are automatically named with their position for error messages

    Code
      case_when(TRUE, 1, 1, 2)
    Error <vctrs_error_assert_ptype>
      `..3` must be a vector with type <logical>.
      Instead, it has type <double>.

---

    Code
      case_when(TRUE, 1, TRUE, "x")
    Error <vctrs_error_incompatible_type>
      Can't combine `..2` <double> and `..4` <character>.

# must be an even number of inputs

    Code
      case_when(TRUE)
    Error <rlang_error>
      `...` must contain an even number of inputs.
      i 1 inputs were provided.

---

    Code
      case_when(TRUE, 1, TRUE)
    Error <rlang_error>
      `...` must contain an even number of inputs.
      i 3 inputs were provided.

# errors with zero inputs

    Code
      case_when()
    Error <rlang_error>
      `...` can't be empty.

---

    Code
      case_when(.default = 1)
    Error <rlang_error>
      `...` can't be empty.

