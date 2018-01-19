# Summary

The app creates a table view with one cell, with a subview hierarchy as follows:
```
Cell                              // UITableViewCell subclass
⌞ UITableViewCellContentView      // standard one, untouched
  ⌞ ContainerView (yellow)        // snapped to content view edges
    ⌞ Label (green)               // snapped to container view layout margins
```

# How to reproduce

1. Launch on iPhone X.
2. Observe: label has no extra padding (green background).
3. Rotate to landscape.
4. Observe: label is truncated
   - Expected: label should take two lines as it's AutomaticDimension and numberOfLines = 0
5. Rotate back to portrait.
6. Observe: label gets extra top and bottom padding
   - Expected: label should have no extra padding, like just after launching.

