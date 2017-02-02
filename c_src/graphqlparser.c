#include "c/GraphQLParser.h"
#include "c/GraphQLAstNode.h"
#include "c/GraphQLAstVisitor.h"
#include "c/GraphQLAst.h"
#include "c/GraphQLAstToJSON.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>


int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("Invalid arguments\n");
        return 1;
    }
    struct GraphQLAstNode *ast;
    const char *json;
    const char *error;

    ast = graphql_parse_string(argv[1], &error);
    if (ast == NULL)
    {
        if (error && strlen(error))
        {
            printf("%s\n", error);
            free((void*)error);
            return 2;
        }
        else
        {
            printf("Unknown error\n");
            return 3;
        }
    }
    json = graphql_ast_to_json(ast);
    if (json)
    {
        printf("%s\n", json);
        free((void*)json);
        return 0;
    }
    return 4;
}