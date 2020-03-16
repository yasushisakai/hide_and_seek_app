#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct {
  uint8_t bytes[640];
} Proof;

Proof prove(const char *to);
