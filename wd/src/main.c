#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "engine.h"

/* 	wd - warp directory 
   It's wrapper for `cd` command which brings some
   addition functions.
*/


/*	BUGS:
   1)+ Help option doesn't work
   2)+ Default option should be jump point
   3)  Program accepts several jump point at once,
        BUT it shouldn't.
   4)  Have to correct argument handler
*/


char *wd_getdir(struct bucket *bucket, char *name) {
	int avail = bucket->avail;
	for (int i = 0; i < avail; i++) {
		if (strcmp(bucket->points[i]->name, name) == 0)
			return bucket->points[i]->dir;
	}
	return NULL;
}

int main(int argc, char **argv)
{
	int index, c;
	int flags[] = { 0, 0, 0 };
	char *(values[]) = { NULL, NULL };
	char *dir;
	struct bucket *bucket = wd_init();

	opterr = 0;

	while ((c = getopt (argc, argv, "a:clhr:")) != -1) {
		switch (c) {
		case 'c':
			flags[0] = 1;
			break;
		case 'h':
			flags[1] = 1;
			break;
		case 'l':
			flags[2] = 1;
			break;
		case 'a':
			values[0] = optarg;
			break;
		case 'r':
			values[1] = optarg;
			break;
		case '?':
			if (optopt == 'a' || optopt == 'r')
				fprintf(stderr, "Option -%c requires argument.\n", optopt);
			else if (isprint(optopt))
				fprintf (stderr, "Unknown option `-%c'.\n", optopt);
			else
				fprintf (stderr,
					"Unknown option character `\\x%x'.\n", optopt);
			return 1;
		default:
			abort();
		}
	}

	/* Jump into directory */
	for (index = optind; index < argc; index++) {
		if ((dir = wd_getdir(bucket, argv[index])) != NULL) {
			printf("%s", dir);
			return 0;
		}
	}

	/* "a:clhr:" */
	if (values[0]) {
		if(wd_add(bucket, values[0]) == 0)
			wd_save(bucket);
		return 0;
	}
	else if (values[1]) {
		if (wd_rm(bucket, values[1]) == 0)
			wd_save(bucket);
		return 0;
	}

	/* Non-option arguments */
	if (flags[0])      wd_clean();
	else if (flags[1]) wd_help();
	else if (flags[2]) wd_list();


	/* Because we won't handle their output as 
		directory path. So return 1 instead of 0.
	*/
	return 1;
}
