# Vagrant Box In Attempting to Compile `libff` to WebAssembly 

in host

```
vagrant up && vagrant ssh 
```

Warning: when running in box, avoid opening the shared directory or modifying files in `./opt` in host as you might encounter the following warning
```
warning:  Clock skew detected.  Your build may be incomplete.
```