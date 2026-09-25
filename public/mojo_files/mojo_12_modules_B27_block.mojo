#include <stdio.h>

extern long long parallel_sum(long long n);

int main(void) {
    printf("sum=%lld\n", parallel_sum(1000));
    return 0;
}
