#include <stdio.h>
#include <conio.h>

int main()
{
	int i, j, times;
	char c;

	
	clrscr();

	
	for( i = 1; i <= 10; i++ )
	{
		gotoxy( 1, i );
		printf( "line # %d", i );
	}

	
	gotoxy(1,12);
	printf("Press any number");
	do
	{
		gotoxy(1,13);
		c = getch();
	}
	while ( c < '0' || c > '9' );


	
	times = (int) c - '0';
	for( j = 1; j <= times; j++ )
	{
		for( i = 1; i <= 10; i++ )
		{
			gotoxy( j*11, i );
			printf( "col #%d", j );
		}
	}

	
	gotoxy(1,13);
	printf("Press The <<any key>> ");
	while( !kbhit() );


	return 0;
}