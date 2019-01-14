## The unit tests must be placed in a folder named "tests"
## at the root of project.
## This Makefile must be placed at the root of project.

DEBUG=		false

# Directory path to sources
SRC_DIR=

# Files to cover
SRC=		$(SRC_DIR) # Add some files

# Directory path to tests sources
SRC_UT_DIR=

SRC_UT=		$(SRC_UT_DIR) # Add some files

OBJ=		$(SRC:.cpp=.o) $(SRC_UT:.cpp=.o)

CC=		g++

COV_OBJ=	$(SRC:.cpp=.gcda) $(SRC:.cpp=.gcno) \
		$(SRC_UT:.cpp=.gcda) $(SRC_UT:.cpp=.gcno)

CXXFLAGS=	-Wall -Wextra -Werror -Weffc++ --coverage

CPPFLAGS=	-I # Path to headers

LDLIBS=		-lcriterion -lgcov

NAME=		unit_tests

GCOVR=		gcovr

GCOVRFLAGS=	--exclude tests/ --branches --html --html-details -o cov/cov.html

# Command executed by our friend, Marvin himself.
tests_run:	$(OBJ)
		$(CC) -o $(NAME) $(OBJ) $(LDFLAGS) $(LDLIBS)
		./$(NAME)

# Open the generated file in Web Browser : file:///$PATH_TO_COV_FOLDER/cov/cov.html
coverage:	tests_run
		if [ ! -d "./cov" ]; then mkdir cov; fi
		$(GCOVR) $(GCOVRFLAGS)
		if [ -f "./cov/cov.html" ]; then xdg-open "./cov/cov.html"; fi

clean:
		rm -f $(OBJ)
		rm -f $(COV_OBJ)

fclean:		clean
		rm -f $(NAME)

re:		fclean tests_run

.PHONY:		re coverage fclean clean tests_run
