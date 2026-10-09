# C03 — Assessment and additional assessment

Assessment principles and the process for establishing or correcting a taxpayer’s liability.

Original notes: [C03_ADD_ASS.qmd](../C03_ADD_ASS.qmd)

Related: [[C02_IT_ILIB]], [[C12_TX_ADMN]], [[C16_TX_ADM_CORP]]

## Original note content

---
title: "Chapter 3: Income tax: Additional aspects"
abstract: |
    Prepare computations of taxable amounts and tax liabilities according to legal requirements and Advise on mitigating and deferring liabilities through **legitimate tax planning measures**.  
    
---

::: {.center data-latex=""}
```{mermaid}
%%| fig-width: 6
%%| fig-align: center
flowchart TD
    %% Main Node
    A([INCOME TAX<br>ADDITIONAL ASPECTS])

    %% First Level Sub-Nodes
    B([RESIDENCE])
    C([RELIEFS AND<br>ALLOWANCES])
    D([CHILD BENEFIT<br>TAX CHARGE])
    E([Individual Savings Accounts<br>ISAs])
    F([ACCRUED<br>INCOME SCHEME])

    %% Second Level Sub-Node
    G([SPOUSE/CIVIL<br>PARTNER<br>PLANNING])

    %% Connections
    A -.- B
    A -.- C
    A -.- D
    A -.- E
    A -.- F
    
    C -.- G

    %% Styling to mimic the rounded blue boxes
    style A fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style B fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style C fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style D fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style E fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style F fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style G fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
```
::: 

# Tax status of an individual

The tax ***residency status*** of an individual determines how much income is assessed to UK tax. 

All persons resident in the UK for tax purposes are assessed to UK tax on their **worldwide income**.


## Definition of residence 

A person is UK resident in the tax year if the individual:

1. Does not meet one of the automatic non-UK residence tests, and
2. Meets one of the automatic UK residence tests, or
3. Meets one or more of the sufficient ties tests.  

These rules are complex in practice; however the examining team have confirmed that the following simplified rules are to be applied in the TX examination.


### Procedure to determine residence 

| Step   | Description                                                                 |
|--------|-----------------------------------------------------------------------------|
| Step 1 | **Check automatic non-UK residence tests** \newline - If satisfy one test = non-UK resident \newline - If not = go to Step 2 |
| Step 2 | **Check automatic UK residence tests** \newline - If satisfy one test = UK resident \newline - If not = go to Step 3 |
| Step 3 | **Determine how many sufficient ties with the UK exist**, and \newline **How many days are spent in the UK in the tax year**, then \newline **Use tax tables to decide status** |

The **order** of the procedure is important because it is possible for an individual to satisfy both one of the automatic non-UK residence tests and one of the automatic UK residence tests, If this is the case:

- the non-UK residence test takes priority and the decision is made at Step 1 
- there is no need to continue to Step 2.

#### Automatic non-UK residency tests

An individual is automatically not UK resident if the individual is ‘in the UK’ in the tax year for less than:

1. 16 days or 
2. 46 days, and has not been UK resident in any of the previous three tax years or
3. 91 days, and works full-time overseas. 

#### Automatic UK residency tests 

An individual is automatically UK resident if:

1. the individual is in the UK for at least 183 days in the tax year or
2. the individual’s only home is in the UK or 
3. the individual works full-time in the UK. 

Note that an individual is ‘in the UK’ if the individual is in the UK at *midnight*.

If the individual does not satisfy any of the automatic tests, the residency status is determined by: 

- how many of the five ‘sufficient ties tests’ are satisfied, and
- how many of the five ‘sufficient ties tests’ are satisfied, and

#### Sufficient ties tests 

To determine whether or not the individual is sufficiently connected to the UK to be considered UK resident, HMRC look at the following five ties:

1. Family: Has close family (a spouse or civil partner or minor children) in the UK 
2. Accommodation: Has accommodation available in the UK which is made use of during the tax year 
3. Work: Does substantive work in the UK 
4. Days in UK: Has spent more than 90 days in the UK in either, or both, of the previous two tax years 
5. Country: Spends more time in the UK than in any other country in the tax year 

To determine the residency status of the individual, consideration is given to: 

| Days in the UK | Previously resident                                    | Not previously resident                                |
|----------------|--------------------------------------------------------|--------------------------------------------------------|
| Less than 16   | Automatically not resident                             | Automatically not resident                             |
| 16 to 45       | Resident if 4 UK ties (or more)                        | Automatically not resident                             |
| 46 to 90       | Resident if 3 UK ties (or more)                        | Resident if 4 UK ties                                  |
| 91 to 120      | Resident if 2 UK ties (or more)                        | Resident if 3 UK ties (or more)                        |
| 121 to 182     | Resident if 1 UK tie (or more)                         | Resident if 2 UK ties (or more)                        |
| 183 or more    | Automatically resident                                 | Automatically resident                                 |

> N: The SRT is a three-step test: first, the automatic non-UK residence tests, then the automatic residence UK tests, and finally the sufficient ties test.

> N: These rules make it more difficult for someone leaving the UK to lose UK residency status than it is for someone arriving in the UK to remain non-UK resident. 

> N: You need to be aware of the definition of residence and be able to apply it to scenarios in the TX examination that will require a written response. 

> N: Income tax computational questions the individual will always be resident in the UK, and liable for tax on worldwide income. You will therefore not be required to calculate tax liabilities for an individual who is not resident in the UK. 


```{mermaid}
%%| fig-width: 6
%%| padding: 2
flowchart TD
    %% Main Top Node
    A("RESIDENT IN UK?")

    %% Level 1 Categories
    B("Automatic<br><b>non-UK residency tests</b>")
    C("Automatic<br><b>UK residency tests</b>")
    D("<b>Sufficient ties tests</b>")

    %% Level 2 Detailed Boxes (Switched to standard rectangles [] for bulletproof text fitting)
    B_Detail["Individual in UK in <b>tax year</b> less<br>than<br>• <b>16 days</b> or<br>• <b>46 days</b> and not UK R for<br>  last 3 years or<br>• <b>91 days</b> and work FT abroad"]
    
    C_Detail["Individual automatically UK R if:<br>• In UK <b>183 days</b> in tax year or<br>• Only home in UK or<br>• Work FT in UK"]
    
    D_Detail["<b>1</b> Close family<br>   - Spouse/Civil partner/<br>     minor child<br><b>2</b> Accommodation in UK<br>   - used in tax year<br><b>3</b> Substantive work in UK<br><b>4</b> Days in UK in last two tax years<br>   - > 90 days in either year<br><b>5</b> Country tie<br>   - Most time spent in UK"]

    %% Level 3 Splits from Sufficient Ties
    subgraph  
    E["<b>Previously resident<br>in UK</b><br>= UK R in one of last 3 years<br><br>Consider <b>all five</b> ties"]
    F["<b>Not previously resident<br>in UK</b><br>= not UK R in any of last 3 years<br><br>Consider <b>first four</b> ties"]
    end
    
    %% Dotted Connections
    A -.- B
    A -.- C
    A -.- D

    B -.- B_Detail
    C -.- C_Detail
    D -.- D_Detail

    D_Detail -.- E
    D_Detail -.- F

    %% Styling to match the original blue theme
    style A fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style B fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style C fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style D fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style B_Detail fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style C_Detail fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style D_Detail fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style E fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
    style F fill:#fff,stroke:#1e3a8a,stroke-width:2px,color:#1e3a8a
```

> ***See Tax tables in exam***

![Exam Table](20260621081430.png)

```{python}
#| eval: false
#| include: false
def check_residency_status():
    print("--- UK Statutory Residence Test (SRT) Simulator ---")
    
    # ---------------------------------------------------------
    # 1. AUTOMATIC NON-UK RESIDENCY TESTS
    # ---------------------------------------------------------
    print("\n[Step 1] Checking Automatic Non-UK Residency Tests...")
    days_in_uk = int(input("How many days did the individual spend in the UK during the tax year? "))
    
    if days_in_uk < 16:
        return "Automatically Non-UK Resident (Less than 16 days in UK)"
        
    not_uk_r_last_3_years = input("Was the individual non-UK resident for ALL of the last 3 tax years? (yes/no): ").strip().lower() == 'yes'
    if days_in_uk < 46 and not_uk_r_last_3_years:
        return "Automatically Non-UK Resident (Less than 46 days and not resident in last 3 years)"
        
    work_ft_abroad = input("Did the individual work full-time abroad during the tax year? (yes/no): ").strip().lower() == 'yes'
    if days_in_uk < 91 and work_ft_abroad:
        return "Automatically Non-UK Resident (Less than 91 days and working full-time abroad)"

    # ---------------------------------------------------------
    # 2. AUTOMATIC UK RESIDENCY TESTS
    # ---------------------------------------------------------
    print("\n[Step 2] Checking Automatic UK Residency Tests...")
    if days_in_uk >= 183:
        return "Automatically UK Resident (183 or more days in the UK)"
        
    only_home_in_uk = input("Was the individual's only home in the UK? (yes/no): ").strip().lower() == 'yes'
    if only_home_in_uk:
        return "Automatically UK Resident (Only home in the UK)"
        
    work_ft_uk = input("Did the individual work full-time in the UK? (yes/no): ").strip().lower() == 'yes'
    if work_ft_uk:
        return "Automatically UK Resident (Working full-time in the UK)"

    # ---------------------------------------------------------
    # 3. SUFFICIENT TIES TESTS
    # ---------------------------------------------------------
    print("\n[Step 3] Checking Sufficient Ties Tests...")
    previously_resident = input("Was the individual resident in the UK in any of the last 3 tax years? (yes/no): ").strip().lower() == 'yes'
    
    # Counting the ties
    ties_count = 0
    
    # Tie 1: Family
    if input("1. Do they have close family (Spouse/Civil partner/minor child) in the UK? (yes/no): ").strip().lower() == 'yes':
        ties_count += 1
        
    # Tie 2: Accommodation
    if input("2. Did they have accommodation available in the UK used during the tax year? (yes/no): ").strip().lower() == 'yes':
        ties_count += 1
        
    # Tie 3: Substantive Work
    if input("3. Did they do substantive work in the UK? (yes/no): ").strip().lower() == 'yes':
        ties_count += 1
        
    # Tie 4: 90-Day Tie
    if input("4. Did they spend > 90 days in the UK in either of the last two tax years? (yes/no): ").strip().lower() == 'yes':
        ties_count += 1
        
    # Tie 5: Country Tie (Only evaluated if previously resident)
    if previously_resident:
        if input("5. Did they spend more time in the UK than in any other country? (yes/no): ").strip().lower() == 'yes':
            ties_count += 1
            
    print(f"\nResulting Ties Counted: {ties_count}")
    if previously_resident:
        print("Status: Previously Resident (Consider all 5 ties)")
    else:
        print("Status: Not Previously Resident (Consider first 4 ties)")
        
    return f"Sufficient Ties evaluated. Refer to the exam tax tables using {ties_count} ties for {days_in_uk} days."

# Run the simulator
if __name__ == "__main__":
    result = check_residency_status()
    print(f"\n>>> FINAL DETERMINATION: {result} <<<")
```


### Statutory Residence Test (SRT) Example

Explain whether or not the following individuals are resident in the UK in the tax year 2025/26.

1. Dieter was born in Germany. He has lived in his home town in Germany until the tax year 2025/26 when he came to the UK to visit on 10 June 2024 until 18 January 2026. 
2. Simone was born in France. She has lived in her home town in France until the tax year 2025/26 when she came to the UK to visit for a month. 
3. Fred has always spent more than 300 days in the UK and has therefore been UK resident. He gave up work on 5 April 2025 and on 18 May 2025 he set off on a round the world holiday. He did not return to the UK until 6 April 2026. \
Initially he spent 5 weeks in his second home in Portugal but then did not spend more than 10 days in any other country whilst he was away. \
Whilst he was away he kept in touch with his wife and young children who remained in the family home in the UK.  
4. Olga, a housewife, has previously visited the UK on holiday for 30 days in each of the last five years and was not UK resident in those years. 
On 6 April 2025 she purchased a holiday cottage in the UK.  \
In the tax year 2025/26 she visited the UK for 80 days, staying in her UK home apart from the two weeks when she stayed with her 17 year old son who had come to study in the UK. \
For the remainder of the year she lived in her home in Germany. 

**Solution**

**1. Dieter**

**Conclusion: Likely UK Resident.**

**Analysis:**
*   **Day Count:** Dieter was in the UK from 10 June 2024 to 18 January 2026. For the 2025/26 tax year, this means he was present from 6 April 2025 to 18 January 2026, which is significantly more than 183 days .
*   **Application of SRT:** Because his UK presence ***exceeds 183 days*** in the tax year, he meets the *first automatic UK test* and is therefore **UK resident** for the entire 2025/26 tax year. *The other steps of the SRT do not need to be considered.

**2. Simone**

**Conclusion: Likely Non-UK Resident.**

**Analysis:**

*   **Day Count:** Simone visited the UK for only one month. This is **less than 46 days** in the 2025/26 tax year.
*   **Application of SRT:** As *she was not UK resident in any of the **three previous tax years*** (the "arriver" rule), she meets the second automatic overseas test . She is therefore **non-UK resident**, and the other tests do not need to be considered.

**3. Fred**

**Conclusion: Likely UK Resident.**

**Analysis:**

*   **Background:** Fred was UK resident before the 2025/26 tax year. ***The SRT makes a distinction between "leavers" (those resident in any of the previous three tax years) and "arrivers"***.
*   **Application of SRT:** Since he was a UK resident in the previous years, he is a "leaver". He does not meet any automatic overseas tests (as he spent 0 days in the UK, he could meet the less-than-16-days test, but he may still have strong ties).
    *   **Sufficient Ties Test:** As a "leaver", he must consider his ties to the UK. The key tie here is the **family tie** . His wife and children remained in the UK family home, so he has a strong family tie .
    *   **Result:** Because *a "leaver" with at least 4 ties needs to have spent more than 16 days in the UK to be resident, You would say he is likely Non-UK Resident if he had less than 4 ties ***BUT*** Fred is a UK resident for the 2025/26 tax year (6 April 2025 to 5 April 2026) ***because he was resident in previous years and spent more than 15 days in the UK during this tax year**. Therefore, he remains a UK resident for the entire 2025/26 tax*

**4. Olga**

**Conclusion: Likely Non-UK Resident.**

**Analysis:**

*   **Day Count:** Olga spent 80 days in the UK in the 2025/26 tax year.
*   **Application of SRT:** She was not UK resident in any of the three previous tax years, so she is an "arriver".
*   **Sufficient Ties Test:** As an "arriver" who spent 80 days in the UK (46-90 days), she must have **all 4 UK ties** to become resident .
    *   **Family Tie:** She has a 17-year-old son studying in the UK, but he is not a minor child. The family tie applies to a spouse, civil partner, or minor children . Her son is over 16, so no family tie.
    *   **Accommodation Tie:** She owns a holiday cottage in the UK and spent nights there, so she has an accommodation tie .
    *   **Work Tie:** She is a housewife and doesn't work, so no work tie.
    *   **90-Day Tie:** She was not UK resident in the previous years, so no 90-day tie .
    *   **Country Tie:** This only applies to "leavers," so it's not considered for an "arriver" .
*   **Result:** She likely has only 1 tie (accommodation), which is fewer than the 3 ties required for an "arriver" spending 80 days in the UK. She is therefore **non-UK resident** .


## Marriage allowance & Child benefit tax charge 

### Marriage allowance - Transferable amount

The marriage allowance (MA) permits a spouse or civil partner to elect to ***transfer a fixed amount of the personal allowance*** to a spouse or civil partner, provided neither spouse (or civil partner) is a higher rate or additional rate taxpayer.

The MA may also be referred to as the **transferable amount** of the PA. 

In practice, however, it will only be beneficial to make the election provided the transferor spouse (or civil partner) does not fully utilise the *PA of £12,570* but the recipient spouse (or civil partner) does, so that their total income tax liability as a couple is reduced. 

Electing for the MA allows the transfer to the other spouse (or civil partner) of a ***fixed amount*** of PA (regardless of the amount of unused PA) equal to:  

**= 10% × the individual personal allowance = £1,260 for 2025/26.**

> There is no provision for transferring more or less than this amount. 

| Item | Amount |
| :--- | :--- |
| Standard Personal Allowance | £12,570 |
| Transferable amount | **10% × £12,570 ~ £1,260** |
| This is a **fixed amount** — not based on actual unused PA | Always £1,260 (2025/26) |

> The transferable amount of the PA of £1,260 is included in the tax rates and allowances provided to you in the examination

> The recipient’s own PA is not increased.

> The effect of the election is that the: 

- the transferring spouse’s PA is reduced by the fixed amount of £1,260.
- the recipient spouse’s income tax liability is reduced by a maximum of £252 (£1,260 MA × 20% basic rate (BR) income tax).

> The relief is given as a deduction from the recipient’s income tax liability, the maximum benefit from the MA is £252 

> If the recipient’s income tax liability is less than £252, a tax repayment is not possible but the amount by which the transferor’s PA is reduced remains £1,260 

> At best the relief reduces the recipient’s income tax liability to £Nil 

#### Marriage allowance tax saving eligibility 

If one spouse (or civil partner) has unused PA of ≥ £1,260:

- the maximum tax saving of £252 will be achieved, provided the recipient spouse has an income tax liability ≥ £252.
- the fixed amount of £1,260 must still be transferred 
- the maximum total tax saving for the couple will be = (unused PA × BR income tax) ~ £252. 

#### Marriage Allowance (MA) election

To be effective for the tax year 2025/26, the election can be made: 

| Timing | Deadline | Effect |
| :--- | :--- | :--- |
| **In advance** (forward-looking) | By **5 April 2026** (end of the tax year) | Election applies to 2025/26 **and continues automatically** for future years unless withdrawn or conditions change |
| **In arrears** (backdating) | By **5 April 2030** (4 years after the end of the tax year) | Election **only** applies to 2025/26 — it does **not** carry forward to future years |

***"In Advance" Election — Key Details***

- **Deadline:** 5 April 2026 (i.e., before the tax year ends)
- **Ongoing effect:** The election remains valid for **all future tax years** until:
  - Either spouse **withdraws** the election, or
  - The **conditions** are no longer met (e.g., transferor's income exceeds PA, or transferee becomes higher rate taxpayer)
- **No need to reapply** each year — it's a "set and forget" until circumstances change

***"In Arrears" Election — Key Details***

- **Deadline:** 5 April 2030 (within 4 years of the end of 2025/26)
- **One‑off effect:** It only applies to **2025/26** — it does **not** roll forward
- **Use case:** If you forgot to claim in time, you can still go back and claim the tax saving for that specific year
- **Practical impact:** You'll get a refund or adjustment for that year only, but you'd need to make a fresh election for future years if you want it to continue


#### Example 1 – Marriage allowance

Kevin and Judy are married. Kevin is employed and has **employment income of £35,500 per annum.** Judy spends most of her time looking after their two children but works on a Saturday, and has **employment income of £6,000.** *They do not have any other income.* 

Judy makes an election to transfer the marriage allowance to Kevin.

Calculate Kevin and Judy’s **income tax liabilities** for the tax year 2025/26. 

**Solution**

|                                         | Kevin (£) | Judy (£) |
|-----------------------------------------|-----------|----------|
| Employment income = net income          | 35,500    | 6,000    |
| Less: PA (Note)                         | (12,570)  | (6,000)  |
| **Taxable income**                      | 22,930    | 0        |
| Income tax liability (£22,930 × 20%)    | 4,586     | 0        |
| Less: MA (£1,260 × 20%)                 | (252)     |          |
| **Income tax liability**                | **4,334** | **0**    |

> N: Judy's personal allowance is reduced to £11,310 (£12,570 – £1,260). This is still more than her total income of £6,000 so she still has no income tax liability. 

### Married couples and civil partners – planning opportunities

A married couple may save tax by making a marriage allowance election to transfer a **fixed amount** of the personal allowance from one spouse to the other.

In addition, a married couple can transfer **income-generating assets** between them, at no tax cost, to minimise their joint tax liability. 

Company shareholdings can be transferred in part, so that both spouses receive dividend income. This will **maximise** the benefit of the **dividend nil rate band**. In total, the couple can receive £1,000 (2 × £500) of dividend income each year without suffering any tax.

### Example 1: Married couples planning opportunities

Ting is married to Ning. She has employment income of £54,000 p.a. She has various bank accounts from which she receives interest of £5,625 each year. 

Ning earns £20,000 trading profits from self-employment each year. He has no other income.

Calculate the **couple’s income tax liabilities** for the tax year 2025/26 and **advise** how they could have saved tax by reorganising their investments. 

**Solution**

**Ting – Income tax computation** 

|                         | Non-savings income (£) | Savings income (£) | Total (£) |
|-------------------------|------------------------|--------------------|-----------|
| Employment income       | 54,000                 |                    | 54,000    |
| Bank interest           |                        | 5,625              | 5,625     |
| **Total income**        | 54,000                 | 5,625              | 59,625    |
| Less: PA                | (12,570)               |                    | (12,570)  |
| **Taxable income**      | 41,430                 | 5,625              | 47,055    |

**Ting - Income tax liability**

| Income tax:                                           | Calculation               | £        |
|-------------------------------------------------------|---------------------------|----------|
| Non-savings income – basic rate                       | 37,700 × 20%              | 7,540    |
| Non-savings income – higher rate                      | 3,730 × 40%               | 1,492    |
| Savings income – nil rate (Note)                      | 500 × 0%                  | 0        |
| Savings income – higher rate                          | 5,125 × 40%               | 2,050    |
| **Income tax liability**                              |                           | **11,082** |

**Ning – Income tax computation**

|                                          | £        |
|------------------------------------------|----------|
| Trading income                           | 20,000   |
| Less: PA                                 | (12,570) |
| **Taxable income**                       | **7,430**|
| Income tax liability (£7,430 × 20%)      | **1,486**|

**Tax saving advice**

Ting is a **higher rate** taxpayer. She has a **savings income nil rate band** of £500 and mainly pays tax on her investment income at 40%. Ning, however, is a **basic rate** taxpayer, and has a savings income nil rate band of £1,000.

If the bank accounts were in Ning’s name **the first £1,000 of interest would be tax-free** and he would pay tax at 20% on the balance of 
£4,625 (5,625 - 1,000). His tax liability on the interest would be £925 and the couple would save tax of £1,125 (i.e. £500 × 40% + £4,625 × 20%) Or (2,050 - 925).

### Child benefit tax charge

Child benefit is a tax-free payment from the Government that can be claimed in respect of children. However, a child benefit income tax charge arises where: 

- an individual receives child benefit, and
- that individual, or the individual’s partner has 'adjusted net income' of £60,000 or more. 

>>> 'Adjusted net income' is calculated in the same way as for the restriction of the personal allowance for high income individuals. 

The tax charge is as follows: 

| Adjusted net income                | Tax charge                                                                 |
|------------------------------------|----------------------------------------------------------------------------|
| Between £60,000 and £80,000        | 1% of child benefit for each £200 of adjusted net income over £60,000      |
| Over £80,000                       | The amount of child benefit received                                       |

>> The thresholds and method of calculating the child benefit tax charge are included in the tax rates and allowances provided to you in the examination, as shown in figure 2:

![Tax Table CBE Exam Sheet](20260625092953.png)

The charge effectively **removes** the child benefit for high income individuals. 

::: {.callout-caution}
REMEMBER

- The PA is gradually reduced for individuals with income in excess of £100,000. 
- The reduction of the PA is based on the taxpayer's Adjusted Net Income (ANI) which is calculated as follows:

| Net income                     |
|--------------------------------|
| Less: Gross gift aid donations  |
| Less: Gross personal pension contributions |
| Adjusted net income (ANI)      |       


> **Key point:** Adjusted net income is **not** used directly to compute taxable income.  
> It is only used to determine **how much Personal Allowance you are entitled to**.


:::

#### Example 1: Child benefit tax charge

Patrick and Hayley are married with two children. Hayley received **child benefit** of £2,252 during the tax year 2025/26. Patrick has no income as he looks after the couple’s children.

Hayley is employed with a salary of £74,000 per annum and has no other source of income. She paid £1,800 (net) to a registered charity under the gift aid scheme during the tax year 2025/26. 

Calculate Hayley’s **income tax liability** for the tax year 2025/26. 

**Solution**

**Taxable Income**

|                                         | £        |
|-----------------------------------------|----------|
| Employment income                       | 74,000   |
| Less: PA                                | (12,570) |
| **Taxable income** (all = non-savings income) | 61,430   |

**Income tax liability**

| Income tax:                                   | £         |
|-----------------------------------------------|-----------|
| Extended Basic rate (39,950 × 20%) (W1)       | 7,990     |
| Higher rate (21,480 × 40%)                    | 8,592     |
| **Income tax liability (before CB charge)**   | **16,582**|
| Add: Child benefit charge (W2)                | 1,306     |
| **Income tax liability**                      | **17,888**|

**W1: Extended basic rate threshold**

|                                                   | £        |
|---------------------------------------------------|----------|
| Current basic rate threshold                      | 37,700   |
| **Add:** Gross gift aid donation (£1,800 × 100/80)| 2,250    |
| **Extended basic rate threshold**                 |**39,950**|

**W2: High Income Child Benefit Charge (HICBC)**

The HICBC threshold is £60,000. To determine the charge, we first find Hayley's Adjusted Net Income (ANI):

$$
\text{ANI} = \text{Trading Profit} - \text{Gross Gift Aid}
$$ 

$$
\text{Gross Gift Aid} = £2,250 
$$ 
$$
\text{ANI} = £74,000 - £2,250 = £71,750
$$ 

The charge is 1% of the child benefit received for every full £200 of ANI exceeding £60,000:
$$
\text{Excess Income} = £71,750 - £60,000 = £11,750
$$ 

$$
\text{Charge Percentage} = \left\lfloor \frac{£11,750}{£200} \right\rfloor = 58\%
$$ 

$$
\text{HICBC} = £2,252 \times 58\% = £1,306.16
$$


```{python}
#| eval: false
#| include: false
def calculate_tax():
    salary = 74000
    gift_aid_net = 1800
    gift_aid_gross = gift_aid_net / 0.8
    child_benefit = 2252
    
    # Adjusted net income
    ani = salary - gift_aid_gross
    print(f"Gross Gift Aid: {gift_aid_gross}")
    print(f"Adjusted Net Income: {ani}")
    
    # Personal allowance
    pa = 12570
    taxable_income = salary - pa
    print(f"Taxable Income: {taxable_income}")
    
    # Bands
    basic_band = 37700 + gift_aid_gross
    print(f"Extended Basic Band: {basic_band}")
    
    # Income tax calculation
    tax_at_20 = basic_band * 0.20
    tax_at_40 = (taxable_income - basic_band) * 0.40
    income_tax = tax_at_20 + tax_at_40
    print(f"Tax at 20%: {tax_at_20}")
    print(f"Tax at 40%: {tax_at_40}")
    print(f"Total Income Tax on earnings: {income_tax}")
    
    # HICBC calculation
    # For 2024/25 onwards: 1% for every £200 above £60,000
    excess = ani - 60000
    hicbc_pct = int(excess // 200) # rounded down to nearest whole percentage in ACCA
    hicbc_charge = child_benefit * (hicbc_pct / 100)
    print(f"HICBC percentage: {hicbc_pct}%")
    print(f"HICBC charge: {hicbc_charge}")
    
    total_liability = income_tax + hicbc_charge
    print(f"Total Income Tax Liability: {total_liability}")

calculate_tax()
```


#### Example 2: 

Rizwan and Gisala live together with their son. Gisala received child benefit of £1,355 during the tax year 2025/26. Rizwan has no income in the tax year 2025/26. Gisala runs a small nursery business and had taxable trading profits of £70,000 for the tax year 2025/26, and paid £2,000 to a charity under the gift aid scheme. 

Calculate Gisala's **income tax liability** for the tax year 2025/26. 

**Solution**


**Taxable Income**

|                                         | £        |
|-----------------------------------------|----------|
| Employment income                       | 70,000   |
| Less: PA                                | (12,570) |
| **Taxable income**                      | 57,430   |

**Income tax liability**

| Income tax:                                   | £         |
|-----------------------------------------------|-----------|
| Extended Basic rate (40,200 × 20%) (W1)       | 8,040     |
| Higher rate (17,230 × 40%)                    | 6,892     |
| **Income tax liability (before CB charge)**   | **14,932**|
| Add: Child benefit charge (W2)                | 508       |
| **Income tax liability**                      | **15,440**|


**W1: Extended basic rate threshold**

|                                                   | £        |
|---------------------------------------------------|----------|
| Current basic rate threshold                      | 37,700   |
| Add: Gross gift aid donation (£2,000 × 100/80)    | 2,500    |
| **Extended basic rate threshold**                  | **40,200** |


**W2: High Income Child Benefit Charge (HICBC)**

The HICBC threshold is £60,000. To determine the charge, we first find Adjusted Net Income (ANI):

$$
\text{ANI} = \text{Trading Profit} - \text{Gross Gift Aid}
$$ 

$$
\text{ANI} = £70,000 - £2,500 = £67,500
$$ 

The charge is 1% of the child benefit received for every full £200 of ANI exceeding £60,000:
$$
\text{Excess Income} = £67,500 - £60,000 = £7,500
$$ 

$$
\text{Charge Percentage} = \left\lfloor \frac{£7,500}{£200} \right\rfloor = 37.5\%
$$ 

$$
\text{HICBC} = £1,355 \times 37.5\% = £508
$$

## Individual savings accounts 

The objective of individual savings accounts (ISAs) is to enable taxpayers to invest in an account that will create income that is ***exempt*** from tax.

**ISA annual subscription limit** 

ISAs have an annual subscription limit for the tax year 2025/26 of **£20,000** per person, which can be invested in a cash ISA and/or a stocks and shares ISA. 

There is no restriction on the **proportion** of the £20,000 limit that can be invested 
in the different types of ISA.

>> Note that spouses and civil partners each have their own limits. 

### Tax reliefs, Withdrawals and reinvestment

An ISA offers the following tax reliefs: 

- **Income** (interest and dividends) is exempt from income tax.
- **Disposals** of investments within an ISA are exempt from capital gains tax. 

**Withdrawals and reinvestment:**

If you withdraw cash from your ISA and later put it back in, that reinvestment ***does not count*** towards your annual subscription limit of £20,000.

Example: If you deposit £20,000 into your ISA, withdraw £5,000, and then reinvest that £5,000, you are still within the limit.

This is because the subscription limit applies to ***new contributions***, not to money that was already inside the ISA and then reintroduced.

If you contributed £20,000 in one tax year, withdrew some of it, and then tried to put that withdrawn amount back in during a later tax year, it would count as a **new contribution** against the new year’s £20,000 limit.

### The main types of ISAs: 

1. **Cash ISAs**   
  This includes bank and building society accounts, as well as those NS&I products where the income is not exempt from tax.

2. **Stocks and shares ISAs**   
  Investment is allowed in shares and securities listed on a stock exchange anywhere in the world. 

The tax advantages of ISAs have been removed for many taxpayers by the introduction of the savings income **nil rate** band (SNRB) and the dividend nil rate band (DNRB): 

***Cash ISAs*** 

- For many basic and higher rate taxpayers, the savings income nil rate band (SNRB) means investing in a **cash ISA no longer provides a tax benefit**. This is because their savings income is within the SNRB and is therefore taxed at 0%. 

- ISAs will still be beneficial for additional rate taxpayers (who are not entitled to a SNRB) and all taxpayers whose SNRB is already **fully utilised**. 

***Stocks and shares ISAs*** 

- For many individuals, the dividend nil rate band (DNRB) means that investing in a stocks and shares ISA no longer provides an income tax benefit. This is because their dividend income is within the DNRB and is therefore taxed at 0%. 
- Stocks and shares ISAs will still be beneficial for taxpayers whose DNRB is already **fully utilised**. 
- In addition, chargeable gains made from investments held within a stocks and shares ISA are exempt from **capital gains tax (CGT)** and these ISAs will therefore be advantageous to taxpayers who make chargeable gains in excess of the annual exempt amount.

### Tax benefit Scenarios (SNRB & DNRB) 'Nil Rate'

#### Cash ISA

- **Basic rate taxpayer** earns £800 in bank interest.  
- The SNRB allows up to £1,000 of savings income taxed at 0%.  
- Result: The £800 interest would be tax‑free even without an ISA.  
- Therefore, putting that £800 into a **cash ISA** provides no additional tax benefit.  

BUT:  

- If the same taxpayer earns £1,500 in interest, £1,000 is covered by the SNRB, leaving £500 taxable.  
- If that £1,500 were inside a **cash ISA**, the full amount would be tax‑free.  
- So ISAs remain useful once the SNRB is fully used.

---

#### Stocks & Shares ISA

- **Higher rate taxpayer** receives £1,000 in dividends.  
- The DNRB allows £500 of dividends taxed at 0%.  
- Result: £500 is tax‑free anyway, and the remaining £500 is taxed at 33.75%.  
- If the £1,000 dividend were inside a **stocks & shares ISA**, the entire £1,000 would be tax‑free.  

Additionally:  

- Any capital gains inside a stocks & shares ISA are exempt from **CGT**.  
- Example: Selling shares for a £15,000 gain. The annual CGT exemption is **£3,000**, so £12,000 would normally be taxable.  
- Inside an ISA, **the full £15,000 gain** is tax‑free.


::: {.callout-caution}
REMEMBER

![CGT](20260627115656.png)
:::

#### SUMMARY

- **Cash ISAs**: Less valuable for many basic/higher rate taxpayers unless their savings income exceeds the SNRB.  
- **Stocks & Shares ISAs**: Valuable for those exceeding the DNRB or making significant capital gains.  
- **Additional rate taxpayers**: Always benefit, since they don’t get SNRB or DNRB allowances.  

## Accrued income scheme 

The accrued income scheme was introduced **to impose a fair income tax charge** on a practice known as **‘bond washing’**.  

Interest is paid on securities such as government bonds (gilts) and corporate bonds at regular intervals (usually six months). As the interest payment date gets nearer, the capital value of the securities increases *as any purchaser is buying the accrued income in addition to the underlying capital value*. 

When the securities are sold they are usually **exempt from CGT** so this element of growth relating to the interest, which is included in the sale proceeds, escapes tax *"Tax avoidance"*.

### Bond washing

This special tax rule applies to *marketable securities* such as loan notes or gilts, (only gilts are examined).  

Bond washing is a tax avoidance strategy ***where a bond is sold just before an interest payment and repurchased afterward (REPOs)*** to convert taxable interest into a capital gain.

Interest is paid to the registered holder on **fixed dates**. An individual vendor who sells the gilt before that date will not receive the next interest payment as by then it will no longer be owned by the vendor. 

However, part of the interest received by the purchaser was actually ***earned 'accrued*** during the vendor’s ownership period.  

Therefore, the price the vendor receives for selling the gilt will be **inflated** to take account of the fact that *the purchaser is due to receive the next interest payment*.

The vendor has received a capital receipt in relation to the sale of the gilt, and as the vendor will not receive interest income, there is (apart from the accrued income scheme) no charge to income tax in respect of the increased selling price. 

As gilts and loan notes are exempt from CGT, any *gain* arising on the disposal will also escape ***capital gains tax***. Overall therefore, any interest due to be paid out and included in the selling price of the gilt will escape tax.

### Accrued income scheme (AIS) Mechanism

The accrued income scheme is designed to prevent investors from avoiding tax on gilt interest by buying or selling just before coupon dates. 

- Interest on gilts is deemed to accrue day by day (though exam questions often simplify to monthly).
- The purchase price (or disposal price) of the gilt is ***apportioned*** between 
the income element and the capital element.
- The income element is *assessed as interest income* for the seller in the tax year when the interest would have been received. 
- The seller is taxed on the income element as if they had received the interest in the tax year when the coupon would have been paid.
- The same income element is **deducted** from the next interest payment received on the gilt by the **purchaser**, when computing the purchaser’s savings income for the tax year when the interest is received.  
- The scheme does not apply unless the total nominal value of gilts held by the individual **exceeds £5,000** at some time during the tax year. 
- **Exemption:** It does not apply if gilts are transferred on death.

### Example 1

Ahmed sold £75,000 of 6% gilts (including accrued interest) on 31 October 2024 for proceeds of £120,000. He originally acquired the gilts on 1 May 2023. Interest is payable on 30 June and 31 December each year. 

Calculate the amount **assessed** on Ahmed **as interest income** from this investment for the tax year 2024/26.

**Solution**

**Facts given**

- Ahmed held **£75,000 nominal of 6% gilts**.  
- Interest dates: **30 June** and **31 December** each year.  
- He sold them on **31 October 2024** for £120,000 (including accrued interest).  
- He originally acquired them on **1 May 2023**.  

**Step‑by‑step under the accrued income scheme**

1. **Interest accrues daily** (exam questions simplify to monthly).  
   - From the last coupon date (30 June 2024) to the sale date (31 October 2024), ***four months of interest accrued***.  

2. **Apportionment of sale proceeds**:  
   - The sale price is split into a **capital element** and an **income element**.  
   - The income element represents the interest accrued up to 31 October 2024.  

3. **Seller’s treatment (Ahmed)**:  
   - That accrued interest is taxed as **savings income** for Ahmed in the tax year when the coupon would have been paid (i.e. 31 December 2024).  
   - So Ahmed is assessed on the accrued interest as if he had received it at the December coupon date.  

4. **Purchaser’s treatment**:  
   - The buyer deducts the same income element from their December coupon when computing taxable savings income.  

**Calculation of Ahmed’s interest income**

- Annual coupon = 6% × £75,000 = **£4,500 per year**.  
- Each half‑year coupon = £2,250.  
- Period from 30 June to 31 October = 4 months out of 6.  
- 
$$
\text{Accrued interest} = £2,250 × \frac{4}{6} = £1,500 
$$

|                                                                    | £        |
|--------------------------------------------------------------------|----------|
| Interest received – 30 June 2024 (£75,000 × 6% × 6/12)             | 2,250    |
| Accrued interest included in selling price of gilts                |          |
| (accrued from 1 July 2024 – 31 October 2024) (£75,000 × 6% × 4/12) | 1,500    |
| **Total interest income assessable for Ahmed**                     | **3,750** |

Therefore, Ahmed is assessed on **£3,750 as interest income** in the tax year 2024/25 (when the December 2024 coupon would have been paid).

> This total **comprises** both the actual interest payment received while holding the gilts and the income deemed to have \underline{arisen upon their sale under the Accrued Income Scheme (AIS)}.

> Since Ahmed owned the gilts on the interest payment date of 30 June 2024, he received the full 6-month semi-annual coupon £2,250

> Under the UK Accrued Income Scheme, when a gilt is sold "cum-div" (including accrued interest), the seller is assessed on the interest accrued from the **last payment** date up to the date of disposal £1,500.

### Example 2

Marguerite ***purchased*** £25,000 of 8% gilts on 30 November 2025, paying £40,000. Interest is payable on 31 January and 31 July each year. 

Calculate the amount **assessed** on Marguerite **as interest income** from this investment for the tax year 2025/26. 

**Solution**

For income tax purposes, she can deduct from the next interest payment received **the interest that was accrued** at purchase.

|                                                                 | £        |
|-----------------------------------------------------------------|----------|
| Interest received – 31 January 2026 (£25,000 × 8% × 6/12)       | 1,000   |
| Deduct: Accrued interest included in cost of gilts at purchase  |         |
| (1 August 2025 – 30 November 2025) (£25,000 × 8% × 4/12)        | (667)   |
| **Gilts interest income assessable in 2025/26**                 | **333** |

::: {.callout-tip}
![Chapter summary](20260627220554.png)
:::

# Practices on Additional aspects

## Objective Test (OT) questions

::: {.callout}



:::

::: {.callout}
Which of the following sources of income is exempt from income tax? 

A) Property income 
B) Salary 
C) **Dividends from shares held in an ISA** 
D) Building society interest 
:::

::: {.callout}
Pierre was born in France. He has been **working full time in the UK** and **been UK resident for tax purposes for the *last five years***. He plans to return to France in the tax year 2025/26.

Assuming he has **two ties** with the UK in the tax year 2025/26 what is the **maximum number of days** that Pierre could spend in the UK **without being treated as UK resident** in the tax year 2025/26? 

A) 91 days 
B) **90 days** 
C) 120 days 
D) 121 days  
:::

## Constructed response questions

::: {.callout}
**Residency status** 

1. Dieter has been in the UK for 222 days in the tax year 2025/26, which is more than 183 days.  
   **Accordingly, he will automatically be treated as UK resident in the tax year 2025/26.** 

2. Simone has not been resident in the UK in any of the three previous tax years, and has been in the UK for less than 46 days in the tax year 2025/26. 
   **Accordingly, she will automatically be treated as not UK resident in the tax year 2025/26.** 

3. Fred spent 42 days in the UK in the tax year 2025/26. He was in the UK in the tax year 2025/26 for between 16 and 45 days and must therefore meet at least **four of the UK ties tests** to be deemed UK resident. 
  Fred meets the: 

    - Close family tie
    - Accommodation tie (made use of a UK house) 
    - Days in UK tie (spent more than 90 days in UK in both of previous two tax years), and 
    - Country tie (spent more time in UK than any other country).

He is therefore UK resident in the tax year 2025/26.

4. Olga has spent too many days in the UK in the tax year 2025/26 to be automatically considered non-UK resident (i.e. > 46 days) and although she has been in the UK for less than 91 days she does not work full-time overseas. 
She has not spent sufficient days in the UK and has a home in Germany therefore she is not automatically UK resident. 
Olga has not been UK resident in any of the previous three tax years. As she has spent between 46 and 90 days in the UK in the tax year 2025/26 she must have four UK ties to be considered UK resident. 
**Olga only meets two UK ties** (close family and house in the UK) and **so is not UK resident** in the tax year 2025/26.  
:::

::: {.callout}
Katie and Emily

**A) Income tax computation – 2025/26**

|                                         | Katie (£) | Emily (£) |
|-----------------------------------------|-----------|-----------|
| Trading income = net income             | 30,000    | 0         |
| Less: PA                                | (12,570)  | (0)       |
| **Taxable income**                      | 17,430    | 0         |
| Income tax liability (£17,430 × 20%)    | 3,486     | 0         |
| Less: MA (£1,260 × 20%) N1              | (252)     |           |
| **Income tax liability**                | **3,234** | **0**     |

> N1: All of Emily’s PA is unused. Maximum benefit of election = £252. 

**B) Income tax computation – 2025/26**

|                                         | Katie (£) | Emily (£) |
|-----------------------------------------|-----------|-----------|
| Trading income = net income             | 13,000    | 0         |
| Less: PA                                | (12,570)  | (0)       |
| **Taxable income**                      | 430       | 0         |
| Income tax liability (£430 × 20%)       | 86        | 0         |
| Less: MA (£1,260 × 20%) restricted N2   | (86)      |           |
| **Income tax liability**                | **0**     | **0**     |

> N2: Emily’s full PA is unused. Maximum benefit of election = restricted as Katie’s income is not sufficient to obtain the full benefit. 

**C) Income tax computation – 2025/26**

|                                         | Katie (£) | Emily (£) |
|-----------------------------------------|-----------|-----------|
| Trading/employment income = net income  | 30,000    | 11,800    |
| Less: PA N3                             | (12,570)  | (11,310)  |
| **Taxable income**                      | 17,430    | 490       |
| Income tax liability (£17,430 × 20%)    | 3,486     |           |
| Income tax liability (£490 × 20%)       |           | 98        |
| Less: MA (£1,260 × 20%)                 | (252)     |           |
| **Income tax liability**                | **3,234** | **98**    |

> N3: if the election is made, the fixed amount of £1,260 must be transferred. Hence why only 11,310 of Emily's PA is used instead of 12,570.

> The couple’s total income tax liability would be:

- With the election £3,332 (£3,234 + £98) 
- Without the election £3,486 (£17,430 × 20%) 
- Tax saving from the election = £154 (£3,486 – £3,332) 
- Alternative calculation = (£770* unused PA × 20%) = £154

> * Unused PA = (12,570 - 11,800) = 770
:::

::: {.callout}

**Taxable income**

|                         | £        |
|-------------------------|----------|
| Trading income          | 70,000   |
| Less: PA                | (12,570) |
| **Taxable income**      | **57,430** |

**Income tax liability**

| Income tax:                             | £          |
|-----------------------------------------|------------|
| Extended Basic rate (40,200 × 20%) (W1) | 8,040      |
| Higher rate (17,230 × 40%)              | 6,892      |
| Add: Child benefit charge (W2)          | 501        |
| **Income tax liability**                | **15,433** |



**(W1) Extension of basic rate band**

|                                                   | £          |
|---------------------------------------------------|------------|
| Current basic rate threshold                      | 37,700     |
| Add: Gross gift aid donation (£2,000 × 100/80)    | 2,500      |
| **Revised basic rate threshold**                  | **40,200** |



**(W2) Child benefit tax charge**

|                                                                              | £        |
|------------------------------------------------------------------------------|----------|
| Child benefit received                                                       | 1,355    |
|                                                                              |          |
| Total income – Net income                                                    | 70,000   |
| Less: Gross gift aid donation (£2,000 × 100/80)                              | (2,500)  |
| **Adjusted net income**                                                      | 67,500   |
| Less: Lower limit                                                            | (60,000) |
| **Excess**                                                                   | 7,500    |
|                                                                              |          |
| 1% per £200 of £7,500 = 37.5% rounded down to 37%                            |          |
| Child benefit charge = 37% of £1,355 (rounded down)                          | **501**  |

:::

::: {.callout}

:::

::: {.callout}

:::


::: {.callout}

:::

::: {.callout}

:::
