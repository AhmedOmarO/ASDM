from math import floor
import pandas as pd 

def ldist(s: str, t: str,sub_cost :int = 1 ) -> int:

    ''' Visualize and calculate the Levenshtein distance table between two strings s and t'''

    m, n = len(s), len(t)
    # dp[i][j] = min edits to convert s[:i] -> t[:j]
    dp = [[0]*(n+1) for _ in range(m+1)]
    for i in range(m+1):
        dp[i][0] = i 
    for j in range(n+1):
        dp[0][j] = j  

    for i in range(1, m+1):
        for j in range(1, n+1):
            
            cost = 0 if s[i-1] == t[j-1] else sub_cost
            dp[i][j] = min(
                dp[i-1][j] + 1,      # delete
                dp[i][j-1] + 1,      # insert
                dp[i-1][j-1] + cost  # substitute (or match)
            )
    # return table where first col is s and first row is t
    for i in range(1,len(dp)):
        print(i)
        dp[i][0] = s[i-1]   

    for j in range(1,len(dp[0])):
        dp[0][j] = t[j-1]
    dp_df = pd.DataFrame(dp)
    return dp_df, dp[m][n]


if __name__ == "__main__":
    # Example usage
    s = "kitten"
    t = "sitting"
    table, distance = ldist(s, t)
    print("Levenshtein distance:", distance)
    print("Distance table:")
    print(table)