# Compatibility Matrix

| Module Version / Kubernetes Version | 1.20.X             | 1.21.X             | 1.22.X             | 1.23.X             | 1.24.X             | 1.25.X             | 1.26.X             | 1.27.X             | 1.28.X             | 1.29.X             | 1.30.X             | 1.31.X             | 1.32.X             | 1.33.X             |1.34.X             |
| ----------------------------------- | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ | ------------------ |------------------ |
| v1.9.2                              | :warning:          | :warning:          | :warning:          | :warning:          |                    |                    |                    |                    |                    |                    |                    |                    |                    |                    |                   |
| v1.9.3                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                    |                    |                    |                    |                    |                    |                   |
| v1.10.0                             |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                    |                    |                    |                    |                   |
| v1.10.1                             |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                    |                    |                    |                    |                   |
| v1.11.0                             |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                    |                    |                    |                   |
| v2.0.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                    |                    |                    |                   |
| v2.1.0                              |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                    |                    |                   |
| v2.2.0                              |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                    |                   |
| v2.3.0                              |                    |                    |                    |                    |                    |                    | :warning:          | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                   |
| v2.4.0                              |                    |                    |                    |                    |                    |                    | :warning:          | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                   |
| v3.0.0                              |                    |                    |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                   |
| v3.1.0                              |                    |                    |                    |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                   |
| v3.2.0                              |                    |                    |                    |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                   |
| v3.2.0                              |                    |                    |                    |                    |                    |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |:white_check_mark: |

:white_check_mark: Compatible

:warning: Has issues

:x: Incompatible

## Warning

- :x:: module version: v1.9.0 has a known bug breaking upgrades. Please do not use.
- :x:: module version: v1.9.1 has a known bug breaking upgrades. Please do not use.

## Legacy versions

| Module Version / Kubernetes Version |       1.14.X       |       1.15.X       |       1.16.X       |       1.17.X       |       1.18.X       |       1.19.X       |       1.20.X       |       1.21.X       |  1.22.X   | 1.23.X |
| ----------------------------------- | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :-------: | :----: |
| v1.3.0                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |           |        |
| v1.3.1                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |           |        |
| v1.4.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |           |        |
| v1.5.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |                    |                    |           |        |
| v1.5.1                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |                    |                    |           |        |
| v1.6.0                              |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |                    |           |        |
| v1.6.1                              |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |                    |           |        |
| v1.7.0                              |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |           |        |
| v1.8.0                              |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning: |        |
| v1.9.0                              |                    |                    |                    |                    |                    |                    |        :x:         |        :x:         |    :x:    |  :x:   |
| v1.9.1                              |                    |                    |                    |                    |                    |                    |        :x:         |        :x:         |    :x:    |  :x:   |
