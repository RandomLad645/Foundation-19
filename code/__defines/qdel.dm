//defines that give qdel hints. these can be given as a return in destory() or by calling

/// `qdel` should queue the object for deletion.
#define QDEL_HINT_QUEUE 0
/// `qdel` should let the object live after calling [/atom/proc/Destroy].
#define QDEL_HINT_LETMELIVE 1
/// Functionally the same as the above. `qdel` should assume the object will gc on its own, and not check it.
#define QDEL_HINT_IWILLGC 2
/// Qdel should assume this object won't GC, and queue a hard delete using a hard reference.
#define QDEL_HINT_HARDDEL 3
// Qdel should assume this object won't gc, and hard delete it posthaste.
#define QDEL_HINT_HARDDEL_NOW 4

#ifdef REFERENCE_TRACKING
/** If REFERENCE_TRACKING is enabled, qdel will call this object's find_references() verb.
 *
 * Functionally identical to [QDEL_HINT_QUEUE] if [GC_FAILURE_HARD_LOOKUP] is not enabled in _compiler_options.dm.
*/
#define QDEL_HINT_FINDREFERENCE 5
/// Behavior as [QDEL_HINT_FINDREFERENCE], but only if the GC fails and a hard delete is forced.
#define QDEL_HINT_IFFAIL_FINDREFERENCE 6
#endif

#define GC_QUEUE_CHECK 1
#define GC_QUEUE_HARDDELETE 2
#define GC_QUEUE_COUNT 2 //increase this when adding more steps.

#define QDEL_ITEM_ADMINS_WARNED (1<<0) //! Set when admins are told about lag causing qdels in this type.
#define QDEL_ITEM_SUSPENDED_FOR_LAG (1<<1) //! Set when a type can no longer be hard deleted on failure because of lag it causes while this happens.

// Defines for the [gc_destroyed][/datum/var/gc_destroyed] var.
#define GC_QUEUED_FOR_QUEUING -1
#define GC_CURRENTLY_BEING_QDELETED -2

#define QDELING(X) (X.gc_destroyed)
#define QDELETED(X) (!X || X.gc_destroyed)
#define QDESTROYING(X) (!X || X.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)

//Qdel helper macros.
#define QDEL_IN(item, time) if(!isnull(item)) {addtimer(CALLBACK(item, /datum/proc/qdel_self), time, TIMER_STOPPABLE)}
#define QDEL_IN_CLIENT_TIME(item, time) if(!isnull(item)) {addtimer(CALLBACK(item, /datum/proc/qdel_self), time, TIMER_STOPPABLE | TIMER_CLIENT_TIME)}
#define QDEL_NULL(item) if(item) {qdel(item); item = null}
#define QDEL_NULL_LIST QDEL_LIST_NULL
#define QDEL_LIST_NULL(x) if(x) { for(var/y in x) { qdel(y) } ; x = null }
#define QDEL_LIST(L) if(L) { for(var/I in L) qdel(I); L.Cut(); }
#define QDEL_LIST_IN(L, time) addtimer(CALLBACK(GLOBAL_PROC, .proc/______qdel_list_wrapper, L), time, TIMER_STOPPABLE)
#define QDEL_LIST_ASSOC(L) if(L) { for(var/I in L) { qdel(L[I]); qdel(I); } L.Cut(); }
#define QDEL_LIST_ASSOC_VAL(L) if(L) { for(var/I in L) qdel(L[I]); L.Cut(); }
