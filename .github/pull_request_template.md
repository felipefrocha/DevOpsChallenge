## Template


**1. What - fix payload lambda para findall stores**

- [ ] There is no conflict with target branch.
- [ ] I have run `sonar` locally and there is no error.
- [ ] I have run `unit tests` locally and there is no error.
- [ ] I have run `migration tests` locally and there is no error.
- [ ] I have run `integrated tests` locally and there is no error.
- [ ] It was approved by nibo tech lead
- [ ] The code has been reviewed

**2. When - Next commit**

- Terraform:
  - Improve isolation: Once the terraform 'landzone' was created, separete the terraform just with resources needed to this applciation
  - Remote State management isolated in another onther repo with state protected
  - Create a subscription/env: In order to better use of my Student account it was used only one subscription
- Improve deploy:
  - Mutations tests
