#include <stddef.h>
#include "ex9_cycle.h"

int ll_has_cycle(node *head) {
    if (head == NULL) return 0;
    node *fast = head, *slow = head;
    while (1)
    {
        fast = fast->next;
        if (fast == NULL) {
            return 0;
        }
        fast = fast->next;
        if (fast == NULL) {
            return 0;
        }
        slow = slow->next;
        if (slow == NULL) {
            return 0;
        }
        if (slow == fast) {
            return 1;
        }
    }
}
