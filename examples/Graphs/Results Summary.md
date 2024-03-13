# Results Summary

Examples of different charts.

## Pie Chart

```mermaid
pie title Findings by Risk
    "CRITICAL" : 0
    "HIGH" : 4
    "MEDIUM" : 10
    "LOW" : 3
    "INFORMATIONAL" : 1
```

## Bar Graph

```mermaid
---
config:
    xyChart:
        width: 900
        height: 600
    themeVariables:
        xyChart:
            titleColor: "#000000"
---
%%{init: {'theme':'forest'}}%%
xychart-beta
    title "Findings by Risk"
    x-axis [CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL]
    y-axis "Number of Findings" 0 --> 13
    bar [0, 4, 10, 3, 1]
```

## Line Graph

```mermaid
---
config:
    xyChart:
        width: 900
        height: 600
    themeVariables:
        xyChart:
            titleColor: "#000000"
---
xychart-beta
    title "Findings by Risk"
    x-axis [CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL]
    y-axis "Number of Findings" 0 --> 13
    line [0, 4, 10, 3, 1]
```

## Bar and Line Combined

```mermaid
---
config:
    xyChart:
        width: 900
        height: 600
    themeVariables:
        xyChart:
            titleColor: "#000000"
---
xychart-beta
    title "Findings by Risk"
    x-axis [CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL]
    y-axis "Number of Findings" 0 --> 13
    bar [0, 4, 10, 3, 1]
    line [0, 4, 10, 3, 1]
```
